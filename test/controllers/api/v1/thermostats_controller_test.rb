require 'test_helper'

class Api::V1::ThermostatsControllerTest < ActionDispatch::IntegrationTest
  test "should get stats" do
    get api_v1_thermostats_stats_url
    assert_response :success
  end

end
