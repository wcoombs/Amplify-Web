class Lead < ApplicationRecord
  validates :email, email: true, presence: true, uniqueness: true
end
