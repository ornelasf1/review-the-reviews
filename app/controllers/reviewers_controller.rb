
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
    @reviewers = Reviewer.joins(:categories).where('categories.name = ? AND reviewers.platform = ?', params[:category], @platform)
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
  
  def edit
    @reviewer = Reviewer.find(params[:id])
  end
  
  def update                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    @reviewer = Reviewer.find(params[:id])

    if @reviewer.update(reviewer_params)
      redirect_to @reviewer
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @reviewer = Reviewer.new
    @reviewer.categories.build
  end

  def create
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

end
