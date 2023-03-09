class PagesController < ApplicationController
  include SearchApi
  def index
    @recent_reviewers = Reviewer.order(:created_at).reverse_order.limit(5)
  end

  def search
    @review_links = get_reviewers_for_product params[:query]
    puts @review_links
    @reviewers = Reviewer.joins(:categories).where('categories.name = ?', params[:category]).where(hostname: @review_links.keys)
  end

  def get_reviewers_for_product query
    reviewers = Reviewer.joins(:categories).where('categories.name = ?', params[:category]).select('reviewers.id, reviewers.name, reviewers.hostname, categories.name as catName, categories.path as catPath')
    urls = reviewers.reject { |reviewer| reviewer.hostname.blank? }.map do |reviewer|
      if reviewer.catPath.blank?
        next reviewer.hostname
      else
        next reviewer.hostname + reviewer.catPath
      end
    end
    hostname_to_reviews_map = search_reviews urls, query
    
    # Transform search api to only get the first review on a product
    hostname_to_reviews_map.each {|key,value| hostname_to_reviews_map[key] = value[0]}
  end
end
