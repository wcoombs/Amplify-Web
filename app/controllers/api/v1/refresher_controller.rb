module Api
  module V1
    class RefresherController < Api::V1::BaseController
      def refresh_access_token
        spotify_account = SpotifyAccount.find_by(host_id: @host.id)
        spotify_api = spotify_account.spotify_api
        access_token = spotify_api.refresh_access_tokens(spotify_account.refresh_token)
        spotify_account.set_access_token(access_token)

        respond_to do |format|
          format.json { render json: { access_token: access_token["access_token"], expires_in: access_token["expires_in"] }, status: :ok }
          format.html { head :forbidden }
        end
      end
    end
  end
end
