class CallbackController < ActionController::Base
  def spotify_callback
    if params[:error].present?
      @response_params = "?error_message=#{params[:error]}"
      return render :spotify_callback
    end

    unless params[:code].present?
      @response_params = "?error_message=missing-auth-code"
      return render :spotify_callback
    end

    tokens = SpotifyApi.new.fetch_tokens(params[:code])
    spotify_account = SpotifyAccount.new
    spotify_account.set_tokens(tokens)
    spotify_api = spotify_account.spotify_api
    me = spotify_api.me

    host = Host.create(email: me["email"])
    spotify_account.update(host: host)
    @response_params = "?api_token=#{host.api_token}"
  end
end
