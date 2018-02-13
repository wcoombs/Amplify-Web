class Room < ApplicationRecord
  has_many :voters
  has_many :songs

  validates :room_code, uniqueness: true, presence: true
end
