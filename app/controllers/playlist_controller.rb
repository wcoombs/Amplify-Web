class PlaylistController < ApplicationController
  helper_method :up_vote, :down_vote

  def show
    room = Room.find(params[:id])
    @songs = room.songs
  end

  def up_vote
    logger.info "Up vote!"
    Vote.create({voter_id: 1, song_id: 1, score: 1})
  end
  def down_vote
    Vote.create({voter_id: 1, song_id: 2, score: -1})
  end
end
