include Mapping
class Song < ApplicationRecord
  has_many :votes
  belongs_to :room
  belongs_to :song_status
  validates :title, presence: true
  validates :artist, presence: true
  validates :duration, presence: true
  validates :uri, presence: true

  def voter_vote(voter)
    votes.where(voter_id: voter.id).first
  end

  def format_from_api(track)
    self.assign_attributes(
        title: track["name"],
        artist: track["artists"][0]["name"],
        duration: track["duration_ms"],
        uri: track["uri"],
        song_status_id: song_statuses[:votable])
  end
end
