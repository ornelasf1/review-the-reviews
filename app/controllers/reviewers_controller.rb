$pageTitleMap = {
  :videogames => 'Video Game'
}

class ReviewersController < ApplicationController
  def index
    @reviewers = Reviewer.where(category: params[:category])
    case params[:filter]
    when 'rated'
      @reviewers = @reviewers.sort {|reviewOne, reviewTwo| reviewerFinalRating(reviewOne) <=> reviewerFinalRating(reviewTwo) }
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

  private
  def reviewerFinalRating reviewer
    if reviewer.reviews.count == 0
      return 0
    end
    finalTotal = reviewer.reviews.reduce(0) do |aggregate, rating|
      total = (rating.wellwritten + rating.usability + rating.entertainment + rating.useful) / 4
      aggregate += total
    end
    finalRating = finalTotal / reviewer.reviews.count
    return finalRating
  end
end
