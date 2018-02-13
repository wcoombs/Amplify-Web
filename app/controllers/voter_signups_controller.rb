class VoterSignupsController < ApplicationController
  def new
  end

  def create
    room = Room.find_by(room_code: params[:room_code])
    unless room.present?
      flash[:error] = "Ooops wrong code bruh"
      return render new_voter_signup_path
    end

    voter = Voter.create(room: room, nickname: params[:nickname])
    if voter.save
      session[:voter_id] = voter.id
      redirect_to playlist_path(room)
    else
      flash[:error] = voter.errors.full_messages.join(". ")
      render new_voter_signup_path
    end
  end
end
