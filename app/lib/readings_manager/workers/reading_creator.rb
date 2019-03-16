# frozen_string_literal: true

module ReadingsManager
  module Workers
    # ReadingsManager::Workers::ReadingCreator
    class ReadingCreator
      include Sidekiq::Worker

      def perform
        p '*' * 80
        p 'ReadingCreator worker'
        p '*' * 80
      end
    end
  end
end
