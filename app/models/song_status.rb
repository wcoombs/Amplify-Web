class SongStatus < ApplicationRecord
  has_one :song
  validates :song_status, presence: true
end