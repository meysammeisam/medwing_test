module Api
  module V1
    class ApplicationController < ActionController::API
      # before_action :authenticate!
      before_action :set_format

      def set_format
        request.format = :json
      end
    end
  end
end
