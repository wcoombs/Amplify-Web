include Mapping
class Song < ApplicationRecord
  has_many :votes
  belongs_to :room
  validates :title, presence: true
  validates :artist, presence: true
  validates :duration, presence: true
  validates :uri, presence: true
  validates :song_status, presence: true

  CURRENTLY_PLAYING_STATUS = 'currently_playing'.freeze
  UP_NEXT_STATUS = 'up_next'.freeze
  VOTABLE_STATUS = 'votable'.freeze

  def voter_vote(voter)
    votes.where(voter_id: voter.id).first
  end

  def format_from_api(track)
    self.assign_attributes(
        title: track["name"],
        artist: track["artists"][0]["name"],
        duration: track["duration_ms"],
        uri: track["uri"])
  end
end
