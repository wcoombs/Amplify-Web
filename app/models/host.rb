class Host < ApplicationRecord
  has_one :room
  has_one :spotify_account
  validates :email, email: true, presence: true, uniqueness: true
  after_create :set_api_token!

  def set_api_token!
    api_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Host.exists?(api_token: random_token)
    end
    self.update!(api_token: api_token)
  end
end
