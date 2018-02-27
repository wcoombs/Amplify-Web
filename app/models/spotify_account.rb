class SpotifyAccount < ApplicationRecord
  belongs_to :host

  def set_tokens(tokens)
    self.attributes = {
      access_token: tokens["access_token"],
      refresh_token: tokens["refresh_token"].presence || refresh_token,
      expires_at: DateTime.current + tokens["expires_in"].to_i.seconds
    }
  end

  def set_access_token(access_token)
    self.attributes = {
      access_token: access_token["access_token"],
      expires_at: DateTime.current + access_token["expires_in"].to_i.seconds
    }
  end

  def spotify_api
    @spotify_api ||= SpotifyApiV1.new(self)
  end
end
