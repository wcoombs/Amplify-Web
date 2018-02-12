require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe "POST#create" do
    it "responds to a json request" do
      process(:create, format: :json)

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["room_code"]).to be_present
      expect(Room.last.songs.count).to eq(5)
    end
  end
end
