require 'rails_helper'

RSpec.describe PlaylistController, type: :controller do
  let(:room_a) { rooms(:room_a) }
  let(:voter_a) { voters(:voter_a) }
  let(:song_c) { songs(:song_c) }

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

  describe "PUT#suggest" do
    it "gets a Spotify song based on song id and saves it" do
      expect do
        Timecop.freeze(Time.zone.parse("2018-03-06 6:00:00")) do
          VCR.use_cassette("suggest_song") do
            process(:suggest, method: :put,
                    params: { id: room_a.id, song_id: "3n3Ppam7vgaVa1iaRUc9Lp" },
                    session: { voter_id: voter_a.id })
          end
        end
      end.to change { Song.count }.by(1)

      song = Song.last
      expect(song.artist).to eq("The Killers")
      expect(song.title).to eq("Mr. Brightside")
      expect(song.duration).to eq(222200)
      expect(song.uri).to eq("spotify:track:3n3Ppam7vgaVa1iaRUc9Lp")
    end

    it "shows a message if the song isn't added" do
      expect do
        Timecop.freeze(Time.zone.parse("2018-03-06 6:00:00")) do
          VCR.use_cassette("suggest_song") do
            process(:suggest, method: :put,
                    params: { id: room_a.id, song_id: "abc" },
                    session: { voter_id: voter_a.id })
          end
        end
      end.to_not change { Song.count }
      expect(flash[:error]).to eq("We're having trouble reaching Spotify, please try again later")
    end
  end
end
