class VoteController < ApplicationController
  include Voting
  def update
    voter = Voter.find(session[:voter_id])
    unless params[:playlist_id].to_i == voter.room_id
      return render json: { error: "forbidden resource" }, status: :forbidden
    end

    song = Song.find(params[:id])
    unless song.room_id == voter.room_id
      return render json: { error: "forbidden resource" }, status: :forbidden
    end

    add_vote(voter, params[:vote].to_i, song )

    render json: { new_score: song.votes.sum(:score) }, status: :ok
  end
end
