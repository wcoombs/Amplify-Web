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
      expect do
        process(:destroy, format: :json, params: { id: room_a.id })
      end.to change { Room.count }.by(-1)
      .and change { Song.count }.by(-2)
      .and change { Voter.count }.by(-1)
      .and change { Vote.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
