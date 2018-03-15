class PlaylistController < ApplicationController
  include Mapping
  before_action :set_room

  def show
    @room = Room.find_by_id(params[:id])
    unless @room.present?
      flash[:error] = "That room does not exist."
      return redirect_to root_path
    end
    voter = @room.voters.detect { |v| v.id == session[:voter_id] }
    unless voter.present?
      flash[:error] = "You must create a user to join this room."
      return redirect_to root_path
    end
    current_song = @room.songs.where(song_status_id: song_statuses[:currently_playing]).first
    current_song = current_song ? current_song.title : "No currently playing song"
    next_song = @room.songs.where(song_status_id: song_statuses[:up_next]).first
    next_song = next_song ? next_song.title : "No songs in the queue"
    @playlist_data = {songs: playlist_data(@room.songs.where(song_status_id: song_statuses[:votable]), voter).sort_by{|s| -s[:total_score]},
                      current_song: current_song,
                      next_song: next_song}
    respond_to do |format|
      format.json { render json: { playlist: @playlist_data }, status: :ok }
      format.html {}
    end
  end

  def suggest
    track = @spotify_api.get_track(params[:song_id])
    new_song = Song.new
    new_song.format_from_api(track)
    new_song.update!(room: @room)
  rescue StandardError => error
    puts "Bad response from Spotify API"
    flash[:error] = "We're having trouble reaching Spotify, please try again later"
  end

  private

  def set_room
    @room = Room.find_by_id(params[:id])
    unless @room.present?
      flash[:error] = "That room does not exist."
      return redirect_to root_path
    end
    @voter = @room.voters.detect { |v| v.id == session[:voter_id] }
    unless @voter.present?
      flash[:error] = "You must create a user to join this room."
      return redirect_to root_path
    end
    @spotify_api = @voter.room.host.spotify_account.spotify_api
    unless @spotify_api.present?
      flash[:error] = "The host must link their Spotify account."
      return redirect_to root_path
    end
  end
end
