class PagesController < ApplicationController
  include SearchApi
  def index
    @recent_reviewers = Reviewer.order(:created_at).reverse_order.limit(5)
  end

  def search
    @review_links = get_reviewers_for_product params[:query]
    @reviewers = Reviewer.where(hostname: @review_links.keys, category: params[:category])
  end

  def get_reviewers_for_product query
    reviewers = Reviewer.where(category: params[:category]).select(:hostname)
    hostnames = reviewers.reject { |reviewer| reviewer.hostname.blank? }.map { |reviewer| reviewer.hostname }
    hostname_to_reviews_map = search_reviews hostnames, query
    
    # Transform search api to only get the first review on a product
    hostname_to_reviews_map.each {|key,value| hostname_to_reviews_map[key] = value[0]}
  end
end
