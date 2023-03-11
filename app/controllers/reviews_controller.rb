class ReviewsController < ApplicationController

  def create
    @reviewer = Reviewer.find(params[:reviewer_id])
    @review = @reviewer.reviews.create(review_params)

    redirect_to reviewer_path(@reviewer)
  end

  private
  def review_params
    params.require(:review).permit(:commenter, :body, rating_attributes: [:wellwritten, :useful, :usability, :entertainment, :quality, :insightful])
  end
end
