class Host < ApplicationRecord
  has_one :room
  validates :email, email: true, presence: true, uniqueness: true
end
