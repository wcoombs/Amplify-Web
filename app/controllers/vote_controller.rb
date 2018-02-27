class VoteController < ApplicationController
  def update
    voter = Voter.find(session[:voter_id])
    unless params[:playlist_id].to_i == voter.room_id
      return render json: { error: "forbidden resource" }, status: :forbidden
    end

    song = Song.find(params[:id])
    unless song.room_id == voter.room_id
      return render json: { error: "forbidden resource" }, status: :forbidden
    end

    vote = Vote.find_or_initialize_by(voter: voter, song: song)
    vote.update(score: params[:vote])

    render json: { new_score: song.votes.sum(:score) }, status: :ok
  end
end
