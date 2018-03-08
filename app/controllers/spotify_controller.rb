class SpotifyController < ApplicationController
  before_action :set_api_by_host

  def search
    response = @spotify_api.search(query: params[:q])
    render json: {response: response}, status: :ok
  rescue StandardError => error
    puts "oh no everything went horribly wrong!"
  end

  private

  def set_api_by_host
    voter = Voter.find(session[:voter_id])
    @spotify_api = voter.room.host.spotify_account.spotify_api
    unless @spotify_account.present?
      flash[:error] = "Search not available: the host has not linked their Spotify account"
      #render something
    end
  end
end