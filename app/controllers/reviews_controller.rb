class ReviewsController < ApplicationController

  def create
    @reviewer = Reviewer.find(params[:reviewer_id])
    @review = @reviewer.reviews.create(review_params)
    @rating = Rating.create(wellwritten: params[:wellwritten], useful: params[:useful], usability: params[:usability], entertainment: params[:entertainment])
    @review.rating = @rating
    redirect_to reviewer_path(@reviewer)
  end

  private
  def review_params
    params.require(:review).permit(:commenter, :body)
  end
end
