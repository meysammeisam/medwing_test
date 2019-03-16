# frozen_string_literal: true

module ReadingsManager
  module Helpers
    # ReadingsManager::Helpers::RedisHelper
    module RedisHelper
      def set(key, value)
        connection.with do |conn|
          conn.set key, value
        end
      end

      def get(key)
        connection.with do |conn|
          conn.get key
        end
      end

      def mget(keys)
        connection.with do |conn|
          conn.mget(*keys)
        end
      end

      def del(key)
        connection.with do |conn|
          conn.del(key)
        end
      end

      def thermostat_seq_number_redis_key(thermostat_id)
        "thermostat_##{thermostat_id}_seq_number"
      end

      def thermostat_redis_key(thermostat_id)
        "thermostat_##{thermostat_id}"
      end

      def global_reading_id_redis_key
        'global_reading_id'
      end

      def reading_redis_key(id)
        "reading_#{id}"
      end

      private

      def connection
        @@connection ||= ConnectionPool::Wrapper.new(size: 5, timeout: 5) do
          redis = Redis.new(url: Rails.application.secrets.readings_manager[:redis_uri])
          redis
        end
      end
    end
  end
end
