$pageTitleMap = {
  :videogames => 'Video Game'
}

class ReviewersController < ApplicationController
  def index
    @reviewers = Reviewer.where(category: params[:category])
    @reviewers = @reviewers.sort {|x,y| y.rating <=> x.rating}
  end

  def show
    @reviewer = Reviewer.find(params[:id])
  end
end
