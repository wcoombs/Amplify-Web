require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe "POST#create" do
    it "responds to a json request" do
      process(:create, format: :json)

      json = JSON.parse(response.body)
      expect(json["room_code"]).to eq("ola")
      expect(response).to have_http_status(:ok)
    end
  end
end
