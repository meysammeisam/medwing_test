module Api
  module V1
    class ReadingsController < ApplicationController
      def create
        render json: { message: 'Readings Create' }
      end

      def show
        render json: { message: "Readings Show #{params[:id]}" }
      end
    end
  end
end
