require 'test_helper'

class Api::MinorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_minors_index_url
    assert_response :success
  end

  test "should get show" do
    get api_minors_show_url
    assert_response :success
  end

end
