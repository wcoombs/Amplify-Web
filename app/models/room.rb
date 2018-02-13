class Room < ApplicationRecord
  has_many :voters, dependent: :destroy
  has_many :songs, dependent: :destroy
end
