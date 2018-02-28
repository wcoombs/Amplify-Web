module Api
  module V1
    class RefresherController < Api::V1::BaseController
      def refresh_access_token
        spotify_account = SpotifyAccount.find_by(host_id: @host.id)
        spotify_account.refresh_token!

        respond_to do |format|
          format.json { render json: { access_token: access_token["access_token"], expires_in: access_token["expires_in"] }, status: :ok }
          format.html { head :forbidden }
        end
      rescue StandardError => error
        Rails.logger.error(error)
        render json: { error: "Failed to refresh the token" }, status: :internal_server_error
      end
    end
  end
end
