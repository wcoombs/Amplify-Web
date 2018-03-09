class VoterSignupsController < ApplicationController
  def new
  end

  def create
    room = Room.find_by(room_code: params[:room_code])
    unless room.present?
      flash[:error] = "Ooops wrong code bruh"
      redirect_to new_voter_signup_path
      return
    end

    voter = Voter.create(room: room, nickname: params[:nickname])
    if voter.save
      session[:voter_id] = voter.id
      redirect_to playlist_path(room)
    else
      flash[:error] = voter.errors.full_messages.join(". ")
      redirect_to new_voter_signup_path
      return
    end
  end
end
