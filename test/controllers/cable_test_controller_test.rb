require "test_helper"

class CableTestControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cable_test_index_url
    assert_response :success
  end
end
