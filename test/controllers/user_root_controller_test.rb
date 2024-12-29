require "test_helper"

class UserRootControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_root_index_url
    assert_response :success
  end
end
