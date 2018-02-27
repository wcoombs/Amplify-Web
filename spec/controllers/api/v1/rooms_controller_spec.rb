require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
  let(:room_a) { rooms(:room_a) }
  let(:host_a) { hosts(:host_a) }

  describe "POST#create" do
    context "it has a valid api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('supergreattoken')
      }

      it "responds to a json request" do
        process(:create, format: :json)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["room_code"]).to be_present
        expect(Room.last.songs.count).to eq(5)
      end
    end

    context "it doesn't have an api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = nil
      }

      it "401s" do
        process(:create, format: :json)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "it has a junk token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('junktoken')
      }

      it "401s" do
        process(:create, format: :json)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE#destroy" do
    context "it has a valid api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('supergreattoken')
      }

      it "performs to a delete request" do
        expect do
          process(:destroy, format: :json, params: { id: room_a.id })
        end.to change { Room.count }.by(-1)
        .and change { Song.count }.by(-2)
        .and change { Voter.count }.by(-1)
        .and change { Vote.count }.by(-1)

        expect(response).to have_http_status(:ok)
      end
    end

    context "it has a junk token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('junktoken')
      }

      it "does not perform the delete request" do
        controller.request.env['HTTP_AUTHORIZATION'] = nil
        process(:destroy, format: :json, params: { id: room_a.id })

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
