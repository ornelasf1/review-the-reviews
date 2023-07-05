class PagesController < ApplicationController
  require 'concurrent'
  include SearchApi
  include Utils
  include ProductSearch

  def index
    @recent_reviewers = Reviewer.order(:created_at).reverse_order.page params[:page]
  end

  def search
    sanitized_query = params[:query].strip
    sanitized_query.squeeze!
    sanitized_query.delete "\n"
    @reviewer = search_reviewer_by_name sanitized_query
    unless @reviewer.blank?
      return redirect_to @reviewer
    end
    
    @reviewers = Reviewer.joins(:categories).where('categories.name = ?', params[:category])
    puts @reviewers.count
    all_review_links = get_reviewers_for_product sanitized_query, params[:category]

    # Get product information for every website found.
    @products_map = get_products all_review_links, params[:category]
    puts @products_map.to_yaml
    puts

    # Show all reviewers that have rated the product first
    @reviewers = @reviewers.sort_by { |reviewer| @products_map.has_key?(reviewer.hostname) && ! @products_map[reviewer.hostname].score.blank? && ! @products_map[reviewer.hostname].name.blank? ? 0 : 1 }
    @reviewers = Kaminari.paginate_array(@reviewers).page(params[:page]).per(10)
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

    hostname_to_reviews_map = Hash.new
    uncached_urls = []
    urls.each do |url|
      cache_key="#{url} #{query} #{category}"
      if not REDIS.blank? and REDIS.exists? cache_key
        puts "Retrieving review urls for '#{cache_key}' from cache."
        hostname_to_reviews_map[url] = JSON.parse(REDIS.get cache_key)
      else
        uncached_urls.append url
      end
    end

    populate_reviews_for_hostname_map uncached_urls, query, category, hostname_to_reviews_map, 0, 0

    hostname_to_reviews_map.each do |hostname, url_buckets|
      cache_key="#{hostname} #{query} #{category}"
      if not REDIS.blank? and not REDIS.exists? cache_key
        puts "Storing '#{cache_key}' into cache."
        REDIS.set cache_key, url_buckets.to_json
      end
    end

    puts
    puts "Reviews found per hostname"
    puts JSON.pretty_generate(hostname_to_reviews_map)
    puts
    
    hostname_to_reviews_map
  end

  def search_reviewer_by_name text
    if text.blank?
      return nil
    end

    format_text = text.strip
    Reviewer.where("name LIKE ?", "%" + Reviewer.sanitize_sql_like(format_text) + "%").first
  end
end
