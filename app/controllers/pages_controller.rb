class PagesController < ApplicationController
  include SearchApi

  def index
    @recent_reviewers = Reviewer.order(:created_at).reverse_order.limit(5).page params[:page]
  end

  def search
    @reviewer = search_reviewer_by_name params[:query]
    unless @reviewer.blank?
      return redirect_to @reviewer
    end

    @review_links = get_reviewers_for_product params[:query]
    puts @review_links
    @reviewers = Reviewer.joins(:categories).where('categories.name = ?', params[:category]).where(hostname: @review_links.keys)
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
    hostname_to_reviews_map = search_reviews urls, query
    
    # Transform search api to only get the first review on a product
    hostname_to_reviews_map.each {|key,value| hostname_to_reviews_map[key] = value[0]}
  end

  def search_reviewer_by_name text
    if text.blank?
      return nil
    end

    format_text = text.strip
    Reviewer.where("name LIKE ?", "%" + Reviewer.sanitize_sql_like(format_text) + "%").first
  end
end
