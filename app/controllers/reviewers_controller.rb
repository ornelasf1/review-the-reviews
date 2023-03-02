$pageTitleMap = {
  :videogames => 'Video Game'
}

class ReviewersController < ApplicationController
  def index
    @reviewers = Reviewer.where(category: params[:category], platform: params[:platform])
    @platform = :platform_website
    @platform = params[:platform] if params[:platform] != nil

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
