class PlaylistController < ApplicationController
  helper_method :has_voted

  def show
    room = Room.find(params[:id])
    @songs = room.songs
    @room_id = room.id
  end

  def has_voted(song_id)
    @song = Song.find_by_id(song_id)
    @song.votes.each do |vote|
      if vote.voter_id === session[:voter_id]
        return vote.score
      end
    end
    return 0
  end
end
