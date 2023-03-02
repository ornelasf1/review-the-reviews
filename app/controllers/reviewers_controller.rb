$pageTitleMap = {
  :videogames => 'Video Game'
}

class ReviewersController < ApplicationController
  def index
    @platform = 'website'
    if params[:platform] != nil
      @platform = params[:platform]
    end
    @reviewers = Reviewer.where(category: params[:category], platform: @platform)

    case params[:filter]
    when 'rated'
      @reviewers = @reviewers.sort {|reviewerOne, reviewerTwo| reviewerOne.finalRating <=> reviewerTwo.finalRating }
    when 'unrated'
      @reviewers = @reviewers.filter {|reviewer| reviewer.reviews.count == 0}
    when 'active'
      @reviewers = @reviewers.filter {|reviewer| reviewer.reviews.count == 0}
    when 'popular'
      @reviewers = @reviewers.sort {|reviewerOne, reviewerTwo| reviewerOne.reviews.count <=> reviewerTwo.reviews.count }
    else
    end
  end

  def show
    @reviewer = Reviewer.find(params[:id])
  end
end
