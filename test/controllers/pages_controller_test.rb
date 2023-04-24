require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get '/'
    assert_response :success
    assert_equal "index", @controller.action_name
    puts @recent_reviewers.to_json
  end

  test "get reviewers for product using reviewers in database" do
    @controller = PagesController.new
    reviewers_to_product_map = @controller.instance_eval{
      @reviewers = Reviewer.joins(:categories).where('categories.name = ?', 'videogames').page 1 # Expects GameSpot in list of reviewers
      get_reviewers_for_product 'god of war 4', 'videogames'
    }   # invoke the private method
    assert(reviewers_to_product_map.keys.include?("www.gamespot.com"), "hostname is in reviewers map as a key")
    assert_not_nil(reviewers_to_product_map["www.gamespot.com"], "no results for reviewer hostname")
  end
end
