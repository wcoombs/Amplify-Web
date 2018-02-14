class Voter < ApplicationRecord
  belongs_to :room
  has_many :votes, dependent: :destroy
  validates :nickname, presence: true
end
