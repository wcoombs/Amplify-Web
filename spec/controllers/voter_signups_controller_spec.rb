require 'rails_helper'

RSpec.describe VoterSignupsController, type: :controller do
  let(:room_a) { rooms(:room_a) }

  describe "GET#show" do
    it "renders the page" do
      process(:new)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST#create" do
    it "allows a voter to signup for a room" do
      expect do
        expect do
          process(:create, params: { nickname: "sean", room_code: "cool123" })
        end.to change { Voter.count }.by(1)
      end.to change { room_a.voters.count }.by(1)

      expect(response).to redirect_to(playlist_path(room_a))
    end

    it "doesn't allow a voter to signup for a room that doesn't exist" do
      expect do
        expect do
          process(:create, params: { nickname: "rob", room_code: "lame123" })
        end.to_not change { Voter.count }
      end.to_not change { room_a.voters.count }
    end
  end
end
