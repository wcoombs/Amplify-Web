class PlaylistController < ApplicationController
  helper_method :has_voted

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
    @playlist_data = playlist_data(@room.songs, voter)
  end

  private

  def playlist_data(songs, voter)
    songs.each.map do |song|
      {
          song_id: song.id,
          title: song.title,
          artist: song.artist,
          voter_score: song.voter_vote(voter)&.score,
          vote_sum: song.votes.sum(:score)
      }
    end
  end


  def has_voted(song_id)
    @vote = Vote.where("song_id = ? AND voter_id = ?", song_id, session[:voter_id]).limit(1).pluck(:score)[0]
  end


end
