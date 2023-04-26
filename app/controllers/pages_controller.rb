class PagesController < ApplicationController
  require 'concurrent'
  include SearchApi
  include Utils

  def index
    @recent_reviewers = Reviewer.order(:created_at).reverse_order.page params[:page]
  end

  def search
    @reviewer = search_reviewer_by_name params[:query]
    unless @reviewer.blank?
      return redirect_to @reviewer
    end
    @reviewers = Reviewer.joins(:categories).where('categories.name = ?', params[:category]).page params[:page]
    puts @reviewers.count
    all_review_links = get_reviewers_for_product params[:query], params[:category]
    all_review_links.each {|k,v| puts "#{k} #{v}\n"} 
    @products_map = get_products all_review_links, params[:category]
    puts @products_map
  end

  private
  def get_reviewers_for_product query, category
    urls = @reviewers.reject { |reviewer| reviewer.hostname.blank? }.map do |reviewer|
      reviewer_category = reviewer.categories.find_by(name: category)
      if reviewer_category.blank? or reviewer_category.path.blank?
        next reviewer.hostname
      else
        next reviewer.hostname + reviewer_category.path
      end
    end
    # hostname_to_reviews_map = search_reviews params[:category], urls, query
    hostname_to_reviews_map = Hash.new
    populate_reviews_for_hostname_map urls, query, category, hostname_to_reviews_map, 0, 0
    
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
        # hostname to product map is keyed with hostname without path because reviewers store only hostname
        hostname_without_path = get_hostname hostname
        scraper = ScraperFactory.getscraper hostname
        if scraper.blank?
          hostname_to_product_map[hostname_without_path] = Product.new(initial_source: urls[0])
          next
        end
        product = nil
        initial_source = nil # We want to know the initial source to show in the product reviews page the first attempted url - it's likely a relavent helpful url even though it mightve failed to be scraped
        for url in urls do
          if initial_source.blank?
            initial_source = url
          end
          product = scraper.getproduct(category.to_sym, url)
          if product.available?
            puts "#{hostname} - found product in #{url}"
            break
          end
          puts "#{hostname} - attempted #{url}"
        end
        product.initial_source = initial_source
        hostname_to_product_map[hostname_without_path] = product
      end
    end
    pool.wait_for_termination 10
    hostname_to_product_map
  end

  def populate_reviews_for_hostname_map urls, query, category, final_hostname_to_reviews_map, stack_max, page_level
    puts "========"
    if urls.blank?
      puts "no more urls"
      return
    end
    if stack_max >= 10
      puts "Reached max stack"
      return
    end
    hostname_to_reviews_map = search_reviews category, urls, query, page_level
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
    populate_reviews_for_hostname_map new_urls, query, category, final_hostname_to_reviews_map, stack_max, page_level
  end
end
