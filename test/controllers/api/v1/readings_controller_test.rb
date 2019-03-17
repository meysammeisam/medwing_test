require 'test_helper'

class Api::V1::ReadingsControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    post '/api/v1/readings/'
    assert_response :unauthorized
  end

  test 'should get show' do
    get '/api/v1/readings/1'
    assert_response :unauthorized
  end
end
