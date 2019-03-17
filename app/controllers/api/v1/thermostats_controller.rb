module Api
  module V1
    class ThermostatsController < ApplicationController
      def stats
        avg_values = ReadingsManager::ThermostatBuilder.new(thermostat_id: @current_thermostat.id).fetch

        render json: avg_values
      end
    end
  end
end
