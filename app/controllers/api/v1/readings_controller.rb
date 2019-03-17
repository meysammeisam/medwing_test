# frozen_string_literal: true

module Api
  module V1
    # Api::V2::ReadingsController
    class ReadingsController < ApplicationController
      before_action :build_handler, only: :create

      def create
        try = 1
        RedisDLM::DLM.with_lock!(obj: @current_thermostat, ttl: 1.second, lock_for: 'pushing_reading') do
          return render json: @reading_handler.reading_orm.reading if @reading_handler.save
        end

        render json: { errors: @reading_handler.reading_orm.errors }, status: :unprocessable_entity
      rescue RedisDLM::Error
        retry if (try += 1) <= 3
      end

      def show
        res = ReadingsManager::Orms::ReadingORM.find(params[:id])
        return head :forbidden if res.blank? || res['thermostat_id'] != @current_thermostat.id

        render json: res
      end

      private

      def reading_params
        params.permit(:temperature, :humidity, :battery_charge)
      end

      def build_handler
        @reading_handler = ReadingsManager::Core.new(
          thermostat_id: @current_thermostat.id,
          temperature: params[:temperature],
          humidity: params[:humidity],
          battery_charge: params[:battery_charge]
        )
      end
    end
  end
end
