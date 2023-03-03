
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

    @reviewers = Reviewer.where(category: params[:category], platform: @platform)
    if @sort_direction == :asc
      @reviewers = @reviewers.sort { |reviewerOne, reviewerTwo| reviewerOne.finalRating <=> reviewerTwo.finalRating }
    else
      @reviewers = @reviewers.sort { |reviewerOne, reviewerTwo| reviewerTwo.finalRating <=> reviewerOne.finalRating }
    end

    if turbo_frame_request?
      respond_to do |format|
        format.html { render partial: 'list', locals: { reviewers: @reviewers }}
      end
    end
  end

  def show
    @reviewer = Reviewer.find(params[:id])
  end

  def new
    @reviewer = Reviewer.new
  end

  def create
    @reviewer = Reviewer.create(reviewer_params)
    if @reviewer.save
      redirect_to reviewers_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def reviewer_params
    params.require(:reviewer).permit(:name, :review, :platform, :website)
  end
end
