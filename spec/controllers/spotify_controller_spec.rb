require 'rails_helper'

RSpec.describe SpotifyController, type: :controller do
  let(:voter_a) { voters(:voter_a) }

  describe "GET#search" do
    it "returns search results from Spotify" do
      Timecop.freeze(Time.zone.parse("2018-03-06 6:00:00")) do
        VCR.use_cassette("spotify_search_success") do
          process(:search, method: :get, params: {q: "Toxic"}, session: {voter_id: voter_a.id})
        end
      end
      expect(response).to have_http_status(:ok)
    end

    it "returns an empty response" do
      Timecop.freeze(Time.zone.parse("2018-03-06 6:00:00")) do
        VCR.use_cassette("spotify_search_failure") do
          process(:search, method: :get, params: {q: "Toxic"}, session: {voter_id: voter_a.id})
        end
      end
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["response"]).to eq({})

    end
  end
end