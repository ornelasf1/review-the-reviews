class PagesController < ApplicationController
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
    hostname_to_reviews_map = search_reviews params[:category], urls, query
    
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
    hostname_to_urls_map.each do |hostname, urls|
      scraper = ScraperFactory.getscraper hostname
      if scraper.blank?
        next
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
    hostname_to_product_map
  end
end
