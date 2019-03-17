# frozen_string_literal: true

module ReadingsManager
  # ReadingsManager::ORMManager
  class ORMManager
    include Helpers::RedisHelper

    def initialize(thermostat_id: nil)
      @thermostat_id = thermostat_id

      # TODO: Use lock on ID to prevent duplication
      @id, @seq_number, @thermostat = initiate_data
      set_id if @id.blank?
      set_seq_number if @seq_number.blank?
      @id, @seq_number = increment_id_and_seq
    end

    def fetch
      @thermostat ||= ReadingsManager::Orms::ThermostatORM.new(thermostat_id: @thermostat_id).save

      @thermostat = JSON.parse(@thermostat) unless @thermostat.is_a?(Hash)
      [@id, @seq_number, @thermostat]
    end

    private

    def initiate_data
      mget(
        [
          global_reading_id_redis_key,
          thermostat_seq_number_redis_key(@thermostat_id),
          thermostat_redis_key(@thermostat_id)
        ]
      )
    end

    def increment_id_and_seq
      connection.with do |conn|
        conn.multi
        conn.incr global_reading_id_redis_key
        conn.incr thermostat_seq_number_redis_key(@thermostat_id)
        conn.exec
      end
    end

    def set_seq_number
      key = thermostat_seq_number_redis_key(@thermostat_id)
      value = ::Reading.where(thermostat_id: @thermostat_id).maximum(:seq_number).to_i
      set(key, value)
    end

    def set_id
      set(global_reading_id_redis_key, ::Reading.maximum(:id).to_i)
    end
  end
end
