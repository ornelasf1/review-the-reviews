class PagesController < ApplicationController
  require 'concurrent'
  include SearchApi

  def index
    @recent_reviewers = Reviewer.order(:created_at).reverse_order.page params[:page]
  end

  def search
    @reviewer = search_reviewer_by_name params[:query]
    unless @reviewer.blank?
      return redirect_to @reviewer
    end

    @review_links = get_reviewers_for_product params[:query]
    puts @review_links
    @products_map = get_products @review_links, params[:category]
    puts @products_map
    @reviewers = Reviewer.joins(:categories).where('categories.name = ?', params[:category]).where(hostname: @review_links.keys).page params[:page]
  end

  private
  def get_reviewers_for_product query
    reviewers = Reviewer.joins(:categories).where('categories.name = ?', params[:category]).select('reviewers.id, reviewers.name, reviewers.hostname, categories.name as catName, categories.path as catPath')
    urls = reviewers.reject { |reviewer| reviewer.hostname.blank? }.map do |reviewer|
      if reviewer.catPath.blank?
        next reviewer.hostname
      else
        next reviewer.hostname + reviewer.catPath
      end
    end
    # hostname_to_reviews_map = search_reviews params[:category], urls, query
    hostname_to_reviews_map = Hash.new
    populate_reviews_for_hostname_map urls, query, hostname_to_reviews_map, 0, 0
    
    # Transform search api to only get the first review on a product
    # hostname_to_reviews_map.each {|key,value| hostname_to_reviews_map[key] = value[0]}
    hostname_to_reviews_map
  end

  def search_reviewer_by_name text
    if text.blank?
      return nil
    end

    format_text = text.strip
    Reviewer.where("name LIKE ?", "%" + Reviewer.sanitize_sql_like(format_text) + "%").first
  end

  def get_products hostname_to_urls_map, category
    hostname_to_product_map = Hash.new
    pool = Concurrent::ThreadPoolExecutor.new(
      min_threads: 5,
      max_threads: 10,
      max_queue: 0
    )
    hostname_to_urls_map.each do |hostname, urls|
      pool.post do
        scraper = ScraperFactory.getscraper hostname
        if scraper.blank?
          return nil
        end
        product = nil
        for url in urls do
          product = scraper.getproduct(category.to_sym, url)
          if product.present?
            break
          end
        end
        hostname_to_product_map[hostname] = product
      end
    end
    pool.wait_for_termination 10
    hostname_to_product_map
  end

  def populate_reviews_for_hostname_map urls, query, final_hostname_to_reviews_map, stack_max, page_level
    puts "========"
    if urls.blank?
      puts "no more urls"
      return
    end
    if stack_max >= 10
      puts "Reached max stack"
      return
    end
    hostname_to_reviews_map = search_reviews params[:category], urls, query, page_level
    if hostname_to_reviews_map.blank?
      puts "No more results"
      return
    end
    puts 'analyze hostname_to_reviews_map'
    puts hostname_to_reviews_map
    puts
    hostname_to_reviews_map.each do |hostname, url_buckets|
      if final_hostname_to_reviews_map.has_key? hostname
        final_hostname_to_reviews_map[hostname] += url_buckets
      else
        final_hostname_to_reviews_map[hostname] = url_buckets
      end
      final_hostname_to_reviews_map[hostname].uniq!
    end
    puts 'analyze final_hostname_to_reviews_map'
    puts final_hostname_to_reviews_map
    puts
    puts "old urls: #{urls}"
    new_urls = urls.reject do |url| 
      final_hostname_to_reviews_map.has_key? url and final_hostname_to_reviews_map[url].size >= 3
    end
    puts "new urls: #{new_urls}"
    puts
    if urls.size == new_urls.size
      page_level += 1
    else
      page_level = 0
    end
    stack_max += 1
    populate_reviews_for_hostname_map new_urls, query, final_hostname_to_reviews_map, stack_max, page_level
  end
end
