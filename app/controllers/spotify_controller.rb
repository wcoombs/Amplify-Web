class SpotifyController < ApplicationController
  before_action :set_api_by_host

  def search
  response = @spotify_api.search(query: params[:q])
  render json: { response: response }, status: :ok
  rescue StandardError => error
    puts "Bad response from Spotify API"
    render json: { response: {}, status: :ok }
  end

  private

  def set_api_by_host
    @voter = Voter.find(session[:voter_id])
    @spotify_api = @voter.room.host.spotify_account.spotify_api
    unless @spotify_api.present?
      flash[:error] = "The host must link their Spotify account."
      redirect_to root_path
    end
  end
end
