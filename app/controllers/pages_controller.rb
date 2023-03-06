class PagesController < ApplicationController
  def index
    @recent_reviewers = Reviewer.order(:created_at).reverse_order.limit(5)
  end

  def search
    relavent_reviewers = get_reviewers_for_product 'god of war 4'
    @reviewers = Reviewer.find(relavent_reviewers)
  end

  def get_reviewers_for_product
    reviewers = Reviewer.where(category: params[:category])
    # search google using reviewers
  end
end
