class ReviewsController < ApplicationController

  def create
    @reviewer = Reviewer.find(params[:reviewer_id])
    @review = @reviewer.reviews.create(review_params)

    # Validator requires at least one of these ratings to be set to create the rating object
    @rating = Rating.create(rating_params)
    @review.rating = @rating

    redirect_to reviewer_path(@reviewer)
  end

  private
  def review_params
    params.require(:review).permit(:commenter, :body)
  end
  def rating_params
    params.require(:rating).permit(:wellwritten, :useful, :usability, :entertainment)
  end
end
