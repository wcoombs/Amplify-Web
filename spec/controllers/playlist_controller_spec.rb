require 'rails_helper'

RSpec.describe PlaylistController, type: :controller do
  describe "GET#show" do
    it "renders the page" do
      process(:new)
      expect(response).to have_http_status(:ok)
    end
  end
end
