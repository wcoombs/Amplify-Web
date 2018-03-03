class SpotifySong < ApplicationRecord
  has_many :votes
  belongs_to :room
end
