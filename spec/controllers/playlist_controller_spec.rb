require 'rails_helper'

RSpec.describe PlaylistController, type: :controller do
  let(:room_a) { rooms(:room_a) }

  describe "GET#show" do
    it "renders the page" do
      process(:show, params: { id: room_a.id })
      expect(response).to have_http_status(:ok)
    end
  end
end
