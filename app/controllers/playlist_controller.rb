class PlaylistController < ApplicationController
  def show
    room = Room.find(params[:id])
    @songs = room.songs
  end
end
