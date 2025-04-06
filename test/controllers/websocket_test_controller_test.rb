require "test_helper"

class WebsocketTestControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get websocket_test_index_url
    assert_response :success
  end
end
