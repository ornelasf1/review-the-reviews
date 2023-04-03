class ReviewsController < ApplicationController

  def new
    @reviewer = Reviewer.find(params[:reviewer_id])
    @review = @reviewer.reviews.new
  end

  def create
    @reviewer = Reviewer.find(params[:reviewer_id])
    if user_signed_in?
      @review = @reviewer.reviews.new(review_params)
      @review.commenter = current_user.profile.name
      @review.user_id = current_user.id

      existing_review = @reviewer.reviews.find_by(user_id: current_user.id)
      if existing_review.present?
        existing_review.destroy
      end

      if @review.save
        @reviews = @reviewer.reviews.order(created_at: :desc).page(params[:page])
        respond_to do |format|
          format.html { redirect_to reviewer_path(@reviewer), notice: 'Thanks for posting!'}
          format.turbo_stream
        end
      else
        render :new, status: :unprocessable_entity
      end
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
        @review = @reviewer.reviews.find_by(id: params[:id], user_id: current_user.id)
      end
      @review.destroy
      redirect_to reviewer_path(@reviewer), status: :see_other
    else
      redirect_to reviewer_path(@reviewer), status: :unauthorized
    end
  end

  private
  def review_params
    params.require(:review).permit(:body, rating_attributes: [:wellwritten, :useful, :usability, :entertainment, :quality, :insightful])
  end
end
