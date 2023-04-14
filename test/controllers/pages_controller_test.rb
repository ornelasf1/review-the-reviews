require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get '/'
    assert_response :success
    assert_equal "index", @controller.action_name
    puts @recent_reviewers.to_json
  end
  test "get reviewers for product" do
    @controller = PagesController.new
    @controller.instance_eval{
      @reviewers = Reviewer.joins(:categories).where('categories.name = ?', 'videogames').page 1
      get_reviewers_for_product 'god of war 4'
    }   # invoke the private method
  end
end
