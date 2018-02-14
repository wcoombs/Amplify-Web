module Api
  module V1
    class HostsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:create]

      def create
        api_token = loop do
          random_token = SecureRandom.urlsafe_base64(nil, false)
          break random_token unless Host.exists?(api_token: random_token)
        end

        new_host = Host.new(email: params[:email], api_token: api_token)
        if new_host.save
          render json: { api_token: api_token }, status: :ok
        else
          render json: { error: "bad request friend" }, status: :bad_request
        end
      end
    end
  end
end
