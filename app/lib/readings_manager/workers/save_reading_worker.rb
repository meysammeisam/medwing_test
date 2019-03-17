# frozen_string_literal: true

module ReadingsManager
  module Workers
    # ReadingsManager::Workers::SaveReadingWorker
    class SaveReadingWorker
      include Sidekiq::Worker

      def perform(reading_redis_key)
        attrs = ReadingsManager::Orms::ReadingORM.new.fetch(reading_redis_key).symbolize_keys
        reading_orm = ReadingsManager::Orms::ReadingORM.new(safe_attributes(attrs))
        reading_orm.reading.save!
        reading_orm.clean(reading_redis_key)
      end

      private

      def safe_attributes(attrs)
        attrs.slice(*allowed_attributes)
      end

      def allowed_attributes
        %i[id thermostat_id seq_number temperature humidity battery_charge]
      end
    end
  end
end
