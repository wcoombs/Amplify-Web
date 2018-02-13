class Voter < ApplicationRecord
  belongs_to :room
  has_many :votes

  validates :nickname, presence: true
end
