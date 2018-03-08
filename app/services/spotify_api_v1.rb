require 'httparty'

class SpotifyApiV1
  include HTTParty

  open_timeout 5
  read_timeout 10
  base_uri "https://api.spotify.com/v1"

  def initialize(spotify_account)
    @access_token = 'BQCWAlz_x2KD38uIeWN-Oz5FZUS2uKvy4i2d53hCUYoKT5ow0TyoPMsxMJ1ZTf3ex1meN_0_X4jxZ2dPLOsSE6oZDcmf9CH7QhtLAXwVQwY5GeT6yLR0lSPqiS7Q_kHYvyrflRbcANHTae1PFDUBbcDad_JepXeB2fKaWw'
  end

  def search(query: nil, type: "track,artist")
    options = { query: { q: query, type: type, market: "US", limit: 10 } }
    send_request(:get, "/search", options)
  end

  def me
    send_request(:get, "/me", {})
  end

  def get_track(id)
    send_request(:get, "/tracks/"+id, {})
  end

  private

  def send_request(action, endpoint, options)
    options[:headers] ||= {}
    options[:headers]["Content-Type"] = "application/json"
    options[:headers]["Accept"] = "application/json"
    options[:headers]["Authorization"] = "Bearer #{@access_token}"
    options[:query] ||= {}
    response = self.class.public_send(action, endpoint, options)
    raise "bad response from spotify v1 api" if response.code != 200
    response.parsed_response
  end
end
