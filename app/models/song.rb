class Song < ApplicationRecord
  has_many :votes
  belongs_to :room

  def voter_vote(voter)
    votes.where(voter_id: voter.id).first
  end
end
