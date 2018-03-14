require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
  let(:room_a) { rooms(:room_a) }
  let(:host_a) { hosts(:host_a) }
  let(:host_c) { hosts(:host_c) }
  let(:room_d) { rooms(:room_d) }
  let(:room_c) { rooms(:room_c) }
  let(:room_e) { rooms(:room_e) }
  let(:room_f) { rooms(:room_f) }

  describe "POST#create" do
    context "it has a valid api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('supergreattoken')
      }

      it "responds to a json request" do
        Room.delete_all
        process(:create, format: :json)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["room_code"]).to be_present
        expect(Room.last.songs.count).to eq(5)
        expect change { Voter.count }.by(1)
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

  describe "GET#index" do
    context "it has a valid api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('supergreattoken2')
      }

      it "responds to a json request with a room" do
        process(:index, format: :json)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["room_code"]).to be_present
        expect(json["voter_id"]).to be_present
      end
    end

    context "it has a valid api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('supergreattoken')
      }

      it "responds to a json request without a room" do
        Room.delete_all
        process(:index, format: :json)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["room_code"]).to be nil
      end
    end

    context "it doesn't have an api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = nil
      }

      it "401s" do
        process(:index, format: :json)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "it has a junk token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('junktoken')
      }

      it "401s" do
        process(:index, format: :json)

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

      it "performs the delete" do
        expect do
          process(:destroy, format: :json, params: { id: room_a.id })
        end.to change { Room.count }.by(-1)
        .and change { Song.count }.by(-2)
        .and change { Voter.count }.by(-1)
        .and change { Vote.count }.by(-1)

        expect(response).to have_http_status(:ok)
      end

      it "fails to delete a room that doesn't belong to the host" do
        expect do
          expect do
            expect do
              expect do
                process(:destroy, format: :json, params: { id: room_d.id })
              end.to_not change { Room.count }
            end.to_not change { Song.count }
          end.to_not change { Voter.count }
        end.to_not change { Vote.count }

        expect(response).to have_http_status(:unauthorized)
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

  describe "GET#show" do
    context "it has a valid api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('supergreattoken2')
      }

      it "shows the playlist" do
        process(:show, format: :json, params: { id: 5555 })

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["playlist"]).to be_present
      end
    end

    context "it has a junk token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('junktoken')
      }

      it "doesn't show the playlist" do
        controller.request.env['HTTP_AUTHORIZATION'] = nil
        process(:show, format: :json, params: { id: room_a.id })

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET#next_song" do
    context "it has a valid api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('besttokenyet')
      }

      it "sends the locked in and next song" do
        process(:next_song, format: :json, params: { room_id: room_d.id })

        json = JSON.parse(response.body)
        expect(json["songs"]).to be_present
        first_song = json["songs"].first
        second_song = json["songs"].second
        expect(first_song["title"]).to eq("hello")
        expect(first_song["locked_in"]).to be_truthy
        expect(second_song["title"]).to eq("goodbye")
        expect(second_song["locked_in"]).to be_truthy
        expect(response).to have_http_status(:ok)
      end

      it "doesn't do anything because thats not your room!" do
        process(:next_song, format: :json, params: { room_id: room_a.id })
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "it has a valid api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('besttokenyet2')
      }

      it "sends no songs" do
        process(:next_song, format: :json, params: { room_id: room_e.id })

        json = JSON.parse(response.body)
        expect(json["songs"]).to be_present
        first_song = json["songs"].first
        second_song = json["songs"].second
        expect(first_song).to be_nil
        expect(second_song).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end

    context "it has a junk token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('junktoken')
      }

      it "doesn't send the locked in and next song" do
        controller.request.env['HTTP_AUTHORIZATION'] = nil
        process(:next_song, format: :json, params: { room_id: room_d.id })

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

   describe "GET#get_voters" do
    context "it has a valid api token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('besttokenyet3')
      }

      it "shows the voter list" do
        process(:get_voters, format: :json, params: { room_id: room_f.id})
        json = JSON.parse(response.body)
        expect(json["voters"]).to be_present
        first_voter = json["voters"].first
        second_voter = json["voters"].second
        third_voter =json["voters"].third
        expect(first_voter).to eq("coolkid")
        expect(second_voter).to eq("yasss")
        expect(third_voter).to eq("Yolo")
      end
    end

    context "it has a junk token" do
      before {
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials('junktoken')
      }

      it "doesn't return voters" do
        controller.request.env['HTTP_AUTHORIZATION'] = nil
        process(:get_voters, format: :json, params: { room_id: room_f.id })

        expect(response).to have_http_status(:unauthorized)
      end
    end
   end
end
