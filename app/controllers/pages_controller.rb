class PagesController < ApplicationController
  require 'concurrent'
  include SearchApi
  include Utils
  include ProductSearch

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

    # Get product information for every website found.
    @products_map = get_products all_review_links, params[:category]
    puts @products_map.to_yaml
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
    puts
    puts "Reviews found per hostname"
    puts JSON.pretty_generate(hostname_to_reviews_map)
    puts
    
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
end
