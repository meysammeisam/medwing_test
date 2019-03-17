# frozen_string_literal: true

module ReadingsManager
  # ReadingsManager::ThermostatBuilder
  class ThermostatBuilder
    include Helpers::RedisHelper

    def initialize(thermostat_id: nil)
      @thermostat_id = thermostat_id
    end

    def save
      initiate_data
    end

    def update(thermostat:, battery_charge:, humidity:, temperature:, seq_number:)
      new_metrics = { 'battery_charge' => battery_charge, 'humidity' => humidity, 'temperature' => temperature }
      current_avg = thermostat
      new_avg = {}

      current_avg.each do |k, v|
        new_avg[k] = weighted_avg(old_avg: v, new_value: new_metrics[k], count: seq_number)
      end

      redis_key = thermostat_redis_key(@thermostat_id)
      set(redis_key, new_avg.to_json)
    end

    def fetch
      redis_key = thermostat_redis_key(@thermostat_id)
      obj = get(redis_key)

      obj || initiate_data
    end

    private

    def initiate_data
      return {} unless @thermostat_id

      key = thermostat_redis_key(@thermostat_id)
      value = initiate_on_air_thermostat
      set(key, value.to_json)

      value
    end

    def initiate_on_air_thermostat
      avg_temperature, avg_humidity, avg_battery_charge = fetch_values_from_db

      {
        temperature: avg_temperature,
        humidity: avg_humidity,
        battery_charge: avg_battery_charge
      }
    end

    def fetch_values_from_db
      Thermostat.find(@thermostat_id).readings.pluck('avg(temperature), avg(humidity), avg(battery_charge)').first
    end

    def weighted_avg(old_avg:, new_value:, count:)
      ((old_avg.to_f * (count.to_i - 1)) + new_value.to_f) / count.to_i
    end
  end
end
