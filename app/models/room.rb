class Room < ApplicationRecord
  has_many :voters, dependent: :destroy
  has_many :songs, dependent: :destroy
  validates :room_code, uniqueness: true, presence: true
end
