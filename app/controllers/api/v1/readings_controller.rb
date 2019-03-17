module Api
  module V1
    class ReadingsController < ApplicationController
      before_action :build_handler, only: :create

      def create
        # TODO: add lock
        return render json: @reading_handler.reading_orm.reading.to_json if @reading_handler.save

        render json: { errors: @reading_handler.reading_orm.errors }, status: :unprocessable_entity
      end

      def show
        res = ReadingsManager::ReadingORM.find(params[:id])
        return head :forbidden if res.blank? || res['thermostat_id'] != @current_thermostat.id

        render json: res
      end

      private

      def reading_params
        params.permit(:temperature, :humidity, :battery_charge)
      end

      def build_handler
        @reading_handler = ReadingsManager::OnAirBuilder.new(
          thermostat_id: @current_thermostat.id,
          temperature: params[:temperature],
          humidity: params[:humidity],
          battery_charge: params[:battery_charge]
        )
      end
    end
  end
end
