class PagesController < ApplicationController
  def index
    @recent_reviewers = Reviewer.order(:created_at).reverse_order.limit(5)
  end
end
