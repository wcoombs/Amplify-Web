require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let(:room_a) { rooms(:room_a) }

  describe "POST#create" do
    it "responds to a json request" do
      process(:create, format: :json)

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["room_code"]).to be_present
      expect(Room.last.songs.count).to eq(5)
    end
  end

  describe "DELETE#destroy" do
    it "responds to a delete request" do
      num_rooms = Room.count

      process(:destroy, format: :json, params: { id: room_a.id })

      expect(response).to have_http_status(:ok)
      expect(Room.count).to eq(num_rooms - 1)
    end
  end
end
