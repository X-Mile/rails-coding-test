require "test_helper"

class WheathersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get wheathers_index_url
    assert_response :success
  end
end
