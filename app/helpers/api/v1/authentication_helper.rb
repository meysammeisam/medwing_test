module Api
  module V1
    module AuthenticationHelper
      def authenticate!
        unless authenticate_request
          head :unauthorized
        end
      end

      private

      def authenticate_request
        return if request.headers['HouseholdToken'].blank?

        @current_thermostat = Thermostat.find_by(household_token: request.headers['HouseholdToken'])
      end
    end
  end
end
