class SpotifyController < ApplicationController
  before_action :set_api_by_host

  def search
    # https://developer.spotify.com/web-api/console/get-search-item/
    response = @spotify_api.search(query: "toxic", type: "track,artist")
    render json: { response: response }, status: :ok
  rescue StandardError => error
    puts "oh no everything went horrible wrong!"
  end

  private

  def set_api_by_host
    voter = Voter.find(session[:voter_id])
    @spotify_api = voter.room.host.spotify_account.spotify_api
    return render some sort of error response here unless @spotify_account.present?
  end
end