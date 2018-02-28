require 'httparty'

class SpotifyApiV1
  include HTTParty

  open_timeout 5
  read_timeout 10
  base_uri "https://api.spotify.com/v1"

  def initialize(spotify_account)
    @access_token = 'BQC12mB9Mwf9OgOCZ55m8CpnAPEyxcRpub8flWxN0lDe_iyGwH9MQu7fs7RGNKUE2pO5aueaIFYBtTi6djngke0sfOUFZ7slgtAIcJiYMl2KvyxviABzvV5E5dOqlwILInO3umjmTadzotuk1cxVA9WusBKRUpADW-YNpA' #spotify_account.access_token
  end

  def search(query: nil, type: "track")
    options = { query: { q: query, type: type, market: "US", limit: 1, offset: 1 } }
    send_request(:get, "/search", options)
  end

  def me
    send_request(:get, "/me", {})
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
