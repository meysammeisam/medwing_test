# frozen_string_literal: true

module ReadingsManager
  # ReadingsManager::OnAirBuilder
  class OnAirBuilder
    include Helpers::RedisHelper

    attr_reader :reading_orm

    def initialize(thermostat_id: nil, humidity: nil, temperature: nil, battery_charge: nil)
      @id, seq_number, @thermostat = ReadingsManager::ORMManager.new(thermostat_id: thermostat_id).fetch

      @reading_orm = ReadingsManager::ReadingORM.new(
        id: @id,
        seq_number: seq_number,
        thermostat_id: thermostat_id,
        humidity: humidity,
        temperature: temperature,
        battery_charge: battery_charge
      )
    end

    def save
      res = @reading_orm.save
      after_save_tasks if res

      res
    end

    private

    def after_save_tasks
      key = reading_redis_key(@id)
      # TODO: update avg values

      ReadingsManager::Workers::SaveReadingWorker.perform_async(key)
    end
  end
end
