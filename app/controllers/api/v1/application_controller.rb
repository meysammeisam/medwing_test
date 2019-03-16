module Api
  module V1
    class ApplicationController < ActionController::API
      include Api::V1::AuthenticationHelper

      before_action :authenticate!
      before_action :set_format

      def set_format
        request.format = :json
      end
    end
  end
end
