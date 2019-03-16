module Api
  module V1
    class ThermostatsController < ApplicationController
      def stats
        render json: { message: "Thermostats Stats #{params[:id]}" }
      end
    end
  end
end
