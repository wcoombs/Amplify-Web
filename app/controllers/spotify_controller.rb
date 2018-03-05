class SpotifyController < ApplicationController
  before_action :set_api_by_host

  def search
    response = @spotify_api.search(query: params[:q], type: "track,artist")
    render json: {response: response}, status: :ok
  rescue StandardError => error
    puts "oh no everything went horrible wrong!"
  end

  def suggest
    room = Room.find_by_id(params[:id])
    track = @spotify_api.get_track(params[:song_id])
    Song.create(
        room: room,
        title: track["name"],
        artist: track["artists"][0]["name"],
        duration: track["duration_ms"],
        uri: track["uri"])
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
