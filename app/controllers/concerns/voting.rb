module Voting
  def add_vote(voter, vote_value, song)

    vote_value = 0 if vote_value.nil?
    vote_value = 1 if vote_value >= 1
    vote_value = -1 if vote_value <= -1


    vote = Vote.find_or_initialize_by(voter: voter, song: song)
    vote.update(score: vote_value)
  end
end