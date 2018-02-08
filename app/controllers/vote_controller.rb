class VoteController < ApplicationController
  def update
    voter = Voter.find(session[:voter_id])
    song = Song.find(params[:id])

    vote = Vote.find_or_initialize_by(voter: voter, song: song)
    vote.update(score: params[:vote])
  end
end
