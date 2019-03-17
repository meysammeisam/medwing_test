# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Get average stats', type: :request do
  describe 'GET show' do
    it 'gets unauthorized with no authorization token provided' do
      get '/api/v1/thermostat/stats'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'gets unauthorized with invalid authorization token' do
      get '/api/v1/thermostat/stats', headers: { 'HouseholdToken' => :invalid_token }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'gets specific thermostat average stats' do
      thermostat = Thermostat.first
      get '/api/v1/thermostat/stats', headers: { 'HouseholdToken' => thermostat.household_token }
      expect(response).to have_http_status(:ok)

      hash_body = JSON.parse(response.body)
      expect(hash_body.keys).to match_array(%w[battery_charge humidity temperature])
    end
  end
end
