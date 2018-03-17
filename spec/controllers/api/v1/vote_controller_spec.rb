require 'rails_helper'

RSpec.describe Api::V1::VoteController, type: :controller do
  let(:room_a) {rooms(:room_a)}
  let(:room_c) {rooms(:room_c)}
  let(:host_a) {hosts(:host_a)}
  let(:host_c) {hosts(:host_c)}
  let(:voter_c) {voters(:voter_c)}
  let(:song_c2) {songs(:song_c2)}

  describe 'POST#vote' do
    context "it has a valid api token" do

      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('supergreattoken')
      }

      it "votes on a valid song" do
        process(:update, format: :json, params: {playlist_id: room_c.id, voter_id: voter_c.id, id: song_c2.id, vote: 1})

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["new_score"]).to be_present
        to change {Vote.count}.by(1)

      end
    end
  end
end



