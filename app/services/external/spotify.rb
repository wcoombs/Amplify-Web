require 'httparty'

module External
  class Spotify
    include HTTParty

    open_timeout 5
    read_timeout 10
    base_uri "https://api.spotify.com/v1"

    def initialize
      api_token = fetch_api_token
      @token_type = api_token["token_type"]
      @access_token = api_token["access_token"]
      @token_expiration = api_token["expires_in"]
      self.class.base_uri "https://api.spotify.com/v1"
    end

    def search(query: nil, type: "track")
      options = { query: { q: query, type: type, market: "US", limit: 1, offset: 1 } }
      send_request(:get, "/search", options)
    end

    private

    def client_auth_value
      ("Basic " + Base64.strict_encode64(Secrets[:spotify_client_id] + ":" + Secrets[:spotify_client_secret]))
    end

    def fetch_api_token
      self.class.base_uri "https://accounts.spotify.com"
      options = { headers: {}, query: {} }
      options[:headers]["Authorization"] = client_auth_value
      options[:query]["grant_type"] = "client_credentials"
      response = self.class.public_send(:post, "/api/token", options)
      response.parsed_response
    end

    def send_request(action, endpoint, options)
      options[:headers] ||= {}
      options[:headers]["Content-Type"] = "application/json"
      options[:headers]["Accept"] = "application/json"
      options[:headers]["Authorization"] = "#{@token_type} #{@access_token}"
      options[:query] ||= {}
      response = self.class.public_send(action, endpoint, options)
      response.parsed_response
    end
  end
end
