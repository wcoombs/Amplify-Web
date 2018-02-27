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
    email = spotify_api.me["email"]
    host = Host.find_by(email: email)

    if host
      host.set_api_tokens!
      host.spotify_account.set_tokens(tokens).save
    else
      host = Host.new(email: email, spotify_account: spotify_account)
      spotify_account.update(host: host)
    end

    if host.save
      @response_params = "?api_token=#{host.api_token}&access_token=#{spotify_account.access_token}".html_safe
    else
      @response_params = "?error_message=error-creating-host"
    end
  end
end
