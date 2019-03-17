# frozen_string_literal: true

module ReadingsManager
  module Orms
    # ReadingsManager::Orms::ReadingORM
    class ReadingORM
      include Helpers::RedisHelper

      attr_reader :reading, :redis_key

      def initialize(args = {})
        @redis_key = reading_redis_key(args[:id])
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

        value = @reading.to_json
        set(@redis_key, value) == 'OK'
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
        orm = new(id: id)

        obj = orm.fetch orm.redis_key
        obj || ::Reading.find(id)
      end
    end
  end
end
