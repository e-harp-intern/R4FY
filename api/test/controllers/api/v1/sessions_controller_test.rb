require "test_helper"

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get api_v1_sessions_new_url
    assert_response :success
  end
end
