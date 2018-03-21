require 'rails_helper'

RSpec.describe Api::V1::VoteController, type: :controller do
  let(:room_a) {rooms(:room_a)}
  let(:room_c) {rooms(:room_c)}
  let(:voter_c) {voters(:voter_c)}
  let(:song_c2) {songs(:song_c2)}
  let(:song_a) {songs(:song_a)}

  describe 'PATCH#vote' do
    context "it has a valid api token" do

      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('supergreattoken2')
      }

      it "allows people to vote on songs in their room" do
        expect do
          process(:update, format: :json, params: {room_id: room_c.id, voter_id: voter_c.id, id: song_c2.id, vote: 1})
        end.to change {Vote.count}.by(1)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["new_score"]).to be_present
        expect(song_c2.votes.sum(:score)).to eq(1)

      end

      it "doesn't allow people vote greater than 1" do
        expect do
          process(:update, format: :json, params: {room_id: room_c.id, voter_id: voter_c.id, id: song_c2.id, vote: 100})
        end.to change {Vote.count}.by(1)
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["new_score"]).to be_present
        expect(song_c2.votes.sum(:score)).to eq(1)
      end

      it "doesn't allow people to vote less than -1" do
        expect do
          process(:update, format: :json, params: {room_id: room_c.id, voter_id: voter_c.id, id: song_c2.id, vote: -100})
        end.to change { Vote.count }.by(1)
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["new_score"]).to be_present
        expect(song_c2.votes.sum(:score)).to eq(-1)
      end

      it "doesn't allow people to vote on songs outside of their room" do
        expect do
          process(:update, format: :json, params: {room_id: room_a.id, voter_id: voter_c.id, id: song_a.id, vote: 1})
        end.to_not change { Vote.count }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:forbidden)
        expect(json["error"]).to be_present
      end
    end

    context "it doesn't have an api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = nil
      }

      it "401s" do
        process(:update, format: :json, params: {room_id: room_c.id, voter_id: voter_c.id, id: song_c2.id, vote: 1})
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "it has a junk token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('junktoken')
      }

      it "401s" do
        process(:update, format: :json, params: {room_id: room_c.id, voter_id: voter_c.id, id: song_c2.id, vote: 1})
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end