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

    it "updates a host" do
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

      expect do
        Timecop.freeze(Time.zone.parse("2018-02-17 8:00:00")) do
          VCR.use_cassette("spotify_callback_success") do
            process(:spotify_callback, method: :get, params: {
                code: "fakeauthcode"
            })
          end
        end
      end.to change { Host.count }.by(0)

      host = Host.last
      spotify_account = host.spotify_account
      expect(host.email).to eq("robert.laurin89@gmail.com")
      expect(spotify_account.access_token).to eq("reallybadaccesstoken")
      expect(spotify_account.refresh_token).to eq("totallyrefreshingtoken")
      expect(spotify_account.expires_at).to eq(Time.zone.parse("2018-02-17 9:00:00"))
    end
  end
end
