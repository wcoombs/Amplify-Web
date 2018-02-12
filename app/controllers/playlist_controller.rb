class PlaylistController < ApplicationController
  helper_method :up_vote, :down_vote

  def show
    room = Room.find(params[:id])
    @songs = room.songs
    @room_id = room.id
  end

  def vote

  end
end
