# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'Api V1 Readings Controller', type: :request do
  describe 'GET show' do
    it 'gets unauthorized with no authorization token provided' do
      get '/api/v1/readings/1'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'gets unauthorized with invalid authorization token' do
      get '/api/v1/readings/1', headers: { 'HouseholdToken' => :invalid_token }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'gets specific reading with valid id' do
      reading = Reading.first
      get "/api/v1/readings/#{reading.id}", headers: { 'HouseholdToken' => reading.thermostat.household_token }
      expect(response).to have_http_status(:ok)

      hash_body = JSON.parse(response.body)
      expect(hash_body.keys).to match_array(reading_show_keys)
    end
  end

  describe 'Create Reading' do
    it 'gets unauthorized with no authorization token provided' do
      post '/api/v1/readings/'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'gets unauthorized with invalid authorization token' do
      post '/api/v1/readings/', headers: { 'HouseholdToken' => :invalid_token }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'gets validation error when requests doesn\'t provide proper params' do
      thermostat = Thermostat.first
      post '/api/v1/readings/', headers: { 'HouseholdToken' => thermostat.household_token }
      expect(response).to have_http_status(:unprocessable_entity)

      hash_body = JSON.parse(response.body)
      expect(hash_body.keys).to match_array(['errors'])
    end

    it 'valid request sets OnAir data' do
      thermostat = Thermostat.first
      expect do
        post '/api/v1/readings/', params: readings_params_1, headers: { 'HouseholdToken' => thermostat.household_token }
      end.to change(ReadingsManager::Workers::SaveReadingWorker.jobs, :size).by(1).
        and change { Reading.count }.by(0) # SAVE DATA ON AIR

      expect(response).to have_http_status(:ok)

      hash_body = JSON.parse(response.body)
      expect(hash_body.keys).to match_array(reading_show_keys)
      expect(hash_body['created_at']).to match(nil)
      expect(hash_body['updated_at']).to match(nil)
      expect(hash_body['temperature']).to match(readings_params_1[:temperature])
      expect(hash_body['battery_charge']).to match(readings_params_1[:battery_charge])
      expect(hash_body['humidity']).to match(readings_params_1[:humidity])

      ### Check the OnAir data
      expect { Reading.find(hash_body['id']) }.to raise_error(ActiveRecord::RecordNotFound)

      get "/api/v1/readings/#{hash_body['id']}", headers: { 'HouseholdToken' => thermostat.household_token }
      expect(response).to have_http_status(:ok)

      hash_body2 = JSON.parse(response.body)
      expect(hash_body2.keys).to match_array(reading_show_keys)
      expect(hash_body2['created_at']).to match(nil)
      expect(hash_body2['updated_at']).to match(nil)
      expect(hash_body2['temperature']).to match(readings_params_1[:temperature])
      expect(hash_body2['battery_charge']).to match(readings_params_1[:battery_charge])
      expect(hash_body2['humidity']).to match(readings_params_1[:humidity])
    end
  end
end

def readings_params_1
  {
    temperature: 1,
    battery_charge: 100,
    humidity: 70
  }
end

def reading_show_keys
  %w[battery_charge created_at humidity id seq_number temperature thermostat_id updated_at]
end
