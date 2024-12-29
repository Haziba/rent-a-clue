require "test_helper"

class RentalsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get rentals_show_url
    assert_response :success
  end
end
