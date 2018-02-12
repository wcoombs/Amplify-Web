class PlaylistController < ApplicationController
  def show
    room = Room.find(params[:id])
    @songs = room.songs
    @room_id = room.id
  end
end
