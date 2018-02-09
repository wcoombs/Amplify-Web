class Room < ApplicationRecord
  has_many :voters
  has_many :songs
end
