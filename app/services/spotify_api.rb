require 'httparty'

class SpotifyApi
  include HTTParty

  open_timeout 5
  read_timeout 10

  def initialize(spotify_account = nil)
    if spotify_account
      @access_token = spotify_account.access_token
    end
  end

  def search(query: nil, type: "track")
    options = { query: { q: query, type: type, market: "US", limit: 1, offset: 1 } }
    send_request(:get, "/search", options)
  end

  def me
    send_request(:get, "/me", {})
  end

  def fetch_tokens(code)
    self.class.base_uri "https://accounts.spotify.com"
    options = { headers: {}, query: {} }
    options[:headers]["Authorization"] = client_auth_value
    options[:query]["grant_type"] = "authorization_code"
    options[:query]["code"] = code
    options[:query]["redirect_uri"] = "https://amplifyapp.ca/spotify_callback"
    response = self.class.public_send(:post, "/api/token", options)
    response.parsed_response
  end

  def refresh_access_tokens(refresh_token)
    self.class.base_uri "https://accounts.spotify.com"
    options = { headers: {}, query: {} }
    options[:headers]["Authorization"] = client_auth_value
    options[:query]["grant_type"] = "refresh_token"
    options[:query]["refresh_token"] = refresh_token
    response = self.class.public_send(:post, "/api/token", options)
    response.parsed_response
  end

  private

  def client_auth_value
    ("Basic " + Base64.strict_encode64(Secrets[:spotify_client_id] + ":" + Secrets[:spotify_client_secret]))
  end

  def send_request(action, endpoint, options)
    self.class.base_uri "https://api.spotify.com/v1"
    options[:headers] ||= {}
    options[:headers]["Content-Type"] = "application/json"
    options[:headers]["Accept"] = "application/json"
    options[:headers]["Authorization"] = "Bearer #{@access_token}"
    options[:query] ||= {}
    response = self.class.public_send(action, endpoint, options)
    response.parsed_response
  end
end
