# frozen_string_literal: true

module ReadingsManager
  # ReadingsManager::ReadingORM
  class ReadingORM
    include Helpers::RedisHelper

    attr_reader :reading

    def initialize(args = {})
      @reading = Reading.new(
        id: args[:id],
        seq_number: args[:seq_number],
        thermostat_id: args[:thermostat_id],
        humidity: args[:humidity],
        temperature: args[:temperature],
        battery_charge: args[:battery_charge]
      )
    end

    def save
      return false unless @reading.valid?

      key = reading_redis_key(@reading.id)
      value = @reading.to_json
      set(key, value) == 'OK'
    end

    def fetch(redis_key)
      on_air_reading = get redis_key
      return unless on_air_reading

      JSON.parse(on_air_reading)
    end

    def clean(redis_key)
      del(redis_key)
    end

    def errors
      @reading.errors.messages
    end

    def self.find(id)
      orm = new

      obj = orm.fetch orm.reading_redis_key(id)
      obj ||= Reading.find(id)

      obj
    end
  end
end
