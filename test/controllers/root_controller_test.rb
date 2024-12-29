require "test_helper"

class RootControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get root_show_url
    assert_response :success
  end
end
