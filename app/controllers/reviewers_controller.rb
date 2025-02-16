
class ReviewersController < ApplicationController
  def index
    @platform = 'website'
    @sort_direction = :asc

    if params[:category].blank?
      redirect_to root_path, status: :see_other
    end

    if params[:platform] != nil
      @platform = params[:platform]
    end
    if params[:sort] != nil
      @sort_direction = params[:sort].to_sym
    end

    @reviewers = Reviewer.joins(:categories).where('categories.name = ? AND reviewers.platform = ?', params[:category], @platform).page(params[:page])
    # if @sort_direction == :asc
    #   @reviewers = @reviewers.sort { |reviewerOne, reviewerTwo| reviewerOne.finalRating <=> reviewerTwo.finalRating }
    # else
    #   @reviewers = @reviewers.sort { |reviewerOne, reviewerTwo| reviewerTwo.finalRating <=> reviewerOne.finalRating }
    # end

    if turbo_frame_request?
      respond_to do |format|
        format.html { render partial: 'list', locals: { reviewers: @reviewers }}
      end
    end
  end

  def show
    @reviewer = Reviewer.find(params[:id])
    @reviews = @reviewer.reviews.order(created_at: :desc).page(params[:page])
    @average_rating = @reviewer.averageRating

    if user_signed_in?
      @review_exists = @reviewer.reviews.find_by(user_id: current_user.id)
    end
  end
  
  def edit
    unless check_authorized
      return
    end
    @reviewer = Reviewer.find(params[:id])
  end
  
  def update
    unless check_authorized
      return
    end
    @reviewer = Reviewer.find(params[:id])

    if @reviewer.update(reviewer_params)
      redirect_to @reviewer
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    unless check_authorized
      return
    end
    @reviewer = Reviewer.new
    @reviewer.categories.build
  end

  def create
    unless check_authorized
      return
    end
    @reviewer = Reviewer.create(reviewer_params)

    if @reviewer.save
      redirect_to reviewers_path @reviewer
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @reviewer = Reviewer.find(params[:id])
    @reviewer.destroy

    redirect_to root_path, status: :see_other
  end

  private
  def reviewer_params
    params.require(:reviewer).permit(:name, :review, :hostname, :platform, categories_attributes: [:name, :path, :id, :_destroy] )
  end

  def check_authorized
    unless user_signed_in? and current_user.is_admin?
      render plain: 'Unauthorized user.', status: :unauthorized
      return false
    end
    return true
  end

end
