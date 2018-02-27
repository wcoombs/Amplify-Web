require 'httparty'

class SpotifyAccountsApi
  include HTTParty

  open_timeout 5
  read_timeout 10
  base_uri "https://accounts.spotify.com"

  def fetch_tokens!(code)
    response = send_request(:post, "/api/token", {
      query: { grant_type: "authorization_code", code: code, redirect_uri: Secrets[:spotify][:redirect_uri] }
    })
  end

  def refresh_access_tokens!(refresh_token)
    response = send_request(:post, "/api/token", {
      query: { grand_type: "refresh_token", refresh_token: refresh_token }
    })
  end

  private

  def client_auth_value
    ("Basic " + Base64.strict_encode64(Secrets[:spotify][:client_id] + ":" + Secrets[:spotify][:client_secret]))
  end

  def send_request(action, endpoint, options)
    options[:headers] ||= {}
    options[:headers]["Authorization"] = client_auth_value
    response = self.class.public_send(:post, endpoint, options)
    raise "bad response from spotify accounts api" if response.code != 200
    response.parsed_response
  end
end
