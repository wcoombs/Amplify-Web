module Api
  module V1
    class BaseController < ActionController::Base
      before_action :authenticate_request

      private

      def authenticate_request
        @host = authenticate_with_http_token do |token, _options|
          Host.find_by(api_token: token)
        end

        render json: { error: 'Invalid or missing api token' }, status: :unauthorized unless @host
      end
    end
  end
end
