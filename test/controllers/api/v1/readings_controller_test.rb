require 'test_helper'

class Api::V1::ReadingsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_readings_create_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_readings_show_url
    assert_response :success
  end

  test "should get stats" do
    get api_v1_readings_stats_url
    assert_response :success
  end

end
