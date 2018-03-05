class Voter < ApplicationRecord
  belongs_to :room
  belongs_to :host, optional: true
  has_many :votes, dependent: :destroy
  validates :nickname, presence: true
end
