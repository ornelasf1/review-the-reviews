
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
  
  def edit
    @reviewer = Reviewer.find(params[:id])
  end
  
  def update
    @reviewer = Reviewer.find(params[:id])
    update_category_paths_json @reviewer, :edit
    if @reviewer.update(reviewer_params)
      redirect_to @reviewer
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @reviewer = Reviewer.new
  end

  def create
    @reviewer = Reviewer.create(reviewer_params)
    update_category_paths_json @reviewer, :new

    if @reviewer.save
      redirect_to reviewers_path(category: params[:reviewer][:category])
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def reviewer_params
    params.require(:reviewer).permit(:name, :review, :hostname, :platform, :category)
  end

  def update_category_paths_json reviewer, render_sym
    catPathUrl = params[:categoryPath]
    unless catPathUrl.blank?
      catPathUrl = catPathUrl.strip
      unless catPathUrl =~ /\A(?:\/[0-9a-zA-Z\-_]*)+\z/
        # TODO: Add error message to categoryPath form
        return render render_sym, status: :unprocessable_entity
      end
      reviewer.categoryPaths[params[:reviewer][:category]] = catPathUrl
    end
  end
end
