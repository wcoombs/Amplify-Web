class PlaylistController < ApplicationController
  helper_method :has_voted

  def show
    room = Room.find(params[:id])
    @songs = room.songs
    @room_id = room.id
  end

  def has_voted(song_id)
    @vote = Vote.where("song_id = ? AND voter_id = ?", song_id, session[:voter_id]).limit(1).pluck(:score)[0]
    if @vote != nil
      return @vote
    else
      return 0
    end
  end
end
