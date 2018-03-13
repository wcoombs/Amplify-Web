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

    vote_value = params[:vote].to_i
    vote_value = 0 if vote_value.nil?
    vote_value = 1 if vote_value >= 1
    vote_value = -1 if vote_value <= -1


    vote = Vote.find_or_initialize_by(voter: voter, song: song)
    vote.update(score: vote_value)

    render json: { new_score: song.votes.sum(:score) }, status: :ok
  end
end
