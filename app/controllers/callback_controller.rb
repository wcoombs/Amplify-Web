class CallbackController < ActionController::Base
  def spotify_callback
    if params[:error].present?
      render json: { error: params[:error] }
    end

    unless params[:code].present?
      render json: { error: "Auth token not provided." }
    end

    tokens = SpotifyApi.new.fetch_tokens(params[:code])
    spotify_account = SpotifyAccount.new
    spotify_account.set_tokens(tokens)
    spotify_api = spotify_account.spotify_api
    me = spotify_api.me

    host = Host.create(email: me["email"])
    spotify_account.update(host: host)
    render json: { api_token: host.api_token }
  end
end

=begin
GET https://accounts.spotify.com/authorize/
?client_id=eca853c70bc24b2d84f9bbd52554074b
&response_type=code
&redirect_uri=https%3A%2F%2Fexample.com%2Fcallback
&scope=user-read-private%20user-read-email

=end

# https://accounts.spotify.com/authorize/?client_id=eca853c70bc24b2d84f9bbd52554074b&response_type=code&redirect_uri=http://50.71.192.157/spotify_callback&scope=user-read-private%20user-read-email
# https://accounts.spotify.com/authorize/?client_id=eca853c70bc24b2d84f9bbd52554074b&response_type=code&redirect_uri=https://amplifyapp.ca/spotify_callback&scope=user-read-private%20user-read-email
# https://accounts.spotify.com/authorize/?client_id=eca853c70bc24b2d84f9bbd52554074b&response_type=code&redirect_uri=https://amplifyapp.ca/spotify_callback&scope=user-read-private%20user-read-email
