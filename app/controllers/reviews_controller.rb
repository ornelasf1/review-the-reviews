class ReviewsController < ApplicationController

  def create
    @reviewer = Reviewer.find(params[:reviewer_id])
    @review = @reviewer.reviews.new(review_params)
    @review.user_id = current_user.id
    @review.save

    redirect_to reviewer_path(@reviewer)
  end

  def destroy
    @reviewer = Reviewer.find(params[:reviewer_id])
    @review = @reviewer.reviews.find(params[:id])
    @review.destroy
    redirect_to reviewer_path(@reviewer), status: :see_other
  end

  private
  def review_params
    params.require(:review).permit(:commenter, :body, rating_attributes: [:wellwritten, :useful, :usability, :entertainment, :quality, :insightful])
  end
end
