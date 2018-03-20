include Mapping
class Song < ApplicationRecord
  has_many :votes
  belongs_to :room
  validates :title, presence: true
  validates :artist, presence: true
  validates :duration, presence: true
  validates :uri, presence: true
  validates :song_status, presence: true

  CURRENTLY_PLAYING_STATUS = 'currently_playing'
  UP_NEXT_STATUS = 'up_next'
  VOTABLE_STATUS = 'votable'

  enum song_status: {
      currently_playing:    CURRENTLY_PLAYING_STATUS,
      up_next:              UP_NEXT_STATUS,
      votable:              VOTABLE_STATUS
  }

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
