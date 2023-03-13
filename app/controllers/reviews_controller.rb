class ReviewsController < ApplicationController

  def create
    @reviewer = Reviewer.find(params[:reviewer_id])
    if user_signed_in?
      @review = @reviewer.reviews.new(review_params)
      @review.user_id = current_user.id
      @review.save
  
      redirect_to reviewer_path(@reviewer)
    else
      redirect_to reviewer_path(@reviewer), status: :unauthorized
    end
  end

  def destroy
    @reviewer = Reviewer.find(params[:reviewer_id])
    if user_signed_in?
      if current_user.is_admin?
        @review = @reviewer.reviews.find(params[:id])
      else
        @review = @reviewer.reviews.find(id: params[:id], user_id: current_user.id)
      end
      @review.destroy
      redirect_to reviewer_path(@reviewer), status: :see_other
    else
      redirect_to reviewer_path(@reviewer), status: :unauthorized
    end
  end

  private
  def review_params
    params.require(:review).permit(:commenter, :body, rating_attributes: [:wellwritten, :useful, :usability, :entertainment, :quality, :insightful])
  end
end
