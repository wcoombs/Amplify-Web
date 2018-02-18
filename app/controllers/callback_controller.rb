class CallbackController < ActionController::Base
  def spotify_callback
    if params[:error].present?
      render json: { error: params[:error] }, status: :bad_request
    end

    unless params[:code].present?
      render json: { error: "Auth token required for callback." }, status: :bad_request
    end

    tokens = SpotifyApi.new.fetch_tokens(params[:code])
    spotify_account = SpotifyAccount.new
    spotify_account.set_tokens(tokens)
    spotify_api = spotify_account.spotify_api
    me = spotify_api.me

    host = Host.create(email: me["email"])
    spotify_account.update(host: host)
    render json: { api_token: host.api_token }, status: :ok
  end
end
