# frozen_string_literal: true

module ReadingsManager
  # ReadingsManager::ThermostatBuilder
  class ThermostatBuilder
    include Helpers::RedisHelper

    def initialize(thermostat_id: nil)
      @thermostat_id = thermostat_id
    end

    def save
      return {} unless @thermostat_id

      initiate_data
    end

    private

    def initiate_data
      key = thermostat_redis_key(@thermostat_id)
      value = build_on_air_thermostat
      set(key, value.to_json)

      value
    end

    def build_on_air_thermostat
      avg_temperature, avg_humidity, avg_battery_charge = fetch_values_from_db

      {
        avg_temperature: avg_temperature,
        avg_humidity: avg_humidity,
        avg_battery_charge: avg_battery_charge
      }
    end

    def fetch_values_from_db
      Thermostat.find(@thermostat_id).readings.pluck('avg(temperature), avg(humidity), avg(battery_charge)').first
    end
  end
end
