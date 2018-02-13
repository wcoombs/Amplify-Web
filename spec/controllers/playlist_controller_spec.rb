require 'rails_helper'

RSpec.describe PlaylistController, type: :controller do
  let(:room_a) { rooms(:room_a) }
  let(:voter_a) { voters(:voter_a) }

  describe "GET#show" do
    it "renders the page" do
      process(:show, params: { id: room_a.id }, session: { voter_id: voter_a.id })
      expect(response).to have_http_status(:ok)
    end

    it "redirects back to the root if they try to join a room they don't belong to" do
      process(:show, params: { id: room_a.id }, session: { voter_id: 100 })
      expect(flash[:error]).to eq("You must create a user to join this room.")
      expect(response).to redirect_to(root_path)
    end

    it "redirects back to the root if they try to join a room that doesn't exist" do
      process(:show, params: { id: 500 }, session: { voter_id: 1 })
      expect(flash[:error]).to eq("That room does not exist.")
      expect(response).to redirect_to(root_path)
    end
  end
end
