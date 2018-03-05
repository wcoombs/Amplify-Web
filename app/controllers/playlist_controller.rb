class PlaylistController < ApplicationController
  before_action :set_room

  def show
    @playlist_data = playlist_data(@room.songs).sort_by{|s| -s[:total_score]}
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
      Rails.logger.error(error)
  end

  private

  def playlist_data(songs)
    songs.each.map do |song|
      {
        id: song.id,
        title: song.title,
        artist: song.artist,
        voter_score: song.voter_vote(@voter)&.score,
        total_score: song.votes.sum(:score)
      }
    end
  end

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
