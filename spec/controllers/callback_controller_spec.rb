require 'rails_helper'

RSpec.describe CallbackController, type: :controller do
  describe "GET#spotify_callback" do
    it "does the callback" do
      expect do
        Timecop.freeze(Time.zone.parse("2018-02-17 6:00:00")) do
          VCR.use_cassette("spotify_callback_success") do
            process(:spotify_callback, method: :get, params: {
              code: "fakeauthcode"
            })
          end
        end
      end.to change { Host.count }.by(1)

      host = Host.last
      spotify_account = host.spotify_account
      expect(host.email).to eq("robert.laurin89@gmail.com")
      expect(spotify_account.access_token).to eq("reallybadaccesstoken")
      expect(spotify_account.refresh_token).to eq("totallyrefreshingtoken")
      expect(spotify_account.expires_at).to eq(Time.zone.parse("2018-02-17 7:00:00"))
    end

    it "does not create multiple accounts for existing hosts" do
      expect do
        expect do
          Timecop.freeze(Time.zone.parse("2018-02-17 6:00:00")) do
            VCR.use_cassette("spotify_callback_success") do
              process(:spotify_callback, method: :get, params: {
                code: "fakeauthcode"
              })
            end
          end
        end.to change { Host.count }.by(1)
      end.to change { SpotifyAccount.count }.by(1)

      expect do
        expect do
          Timecop.freeze(Time.zone.parse("2018-02-17 6:00:00")) do
            VCR.use_cassette("spotify_callback_success") do
              process(:spotify_callback, method: :get, params: {
                code: "fakeauthcode"
              })
            end
          end
        end.to_not change { Host.count }
      end.to_not change { SpotifyAccount.count }

      host = Host.last
      spotify_account = host.spotify_account
      expect(host.email).to eq("robert.laurin89@gmail.com")
      expect(spotify_account.access_token).to eq("reallybadaccesstoken")
      expect(spotify_account.refresh_token).to eq("totallyrefreshingtoken")
      expect(spotify_account.expires_at).to eq(Time.zone.parse("2018-02-17 7:00:00"))
    end

    it "it doesn't create anything on a failed callback." do
      expect do
        expect do
          Timecop.freeze(Time.zone.parse("2018-02-17 6:00:00")) do
            VCR.use_cassette("spotify_callback_failure") do
              process(:spotify_callback, method: :get, params: {
                code: "fakeauthcode"
              })
            end
          end
        end.to_not change { Host.count }
      end.to_not change { SpotifyAccount.count }
    end
  end
end
