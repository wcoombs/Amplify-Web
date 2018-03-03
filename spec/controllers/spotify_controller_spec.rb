require 'rails_helper'

RSpec.describe SpotifyController, type: :controller do
  describe "GET#search" do
    it "returns search results from Spotify" do
      expect_any_instance_of(SpotifyApiV1).to receive(:search).with(anything).and_return("something")
      process(:search, method: :get, params: { q: "Toxic"})
      expect(json[""]).to be_present # or .to eq("some value")
    end
  end
end