class Song < ApplicationRecord
  has_many :votes
  belongs_to :room
  validates :title, presence: true
  validates :artist, presence: true
  validates :duration, presence: true
  validates :uri, presence: true

  def voter_vote(voter)
    votes.where(voter_id: voter.id).first
  end
end
