class VoterSignupsController < ApplicationController
  def new
  end

  def create
    room = Room.find_by(room_code: params[:room_code].upcase)
    if room.nil?
      flash[:error] = "Ooops wrong code bruh"
      render new_voter_signup_path
    else
      voter = Voter.create(room: room, nickname: params[:nickname])
      session[:voter_id] = voter.id
      redirect_to playlist_path(room)
    end
  end
end
