class VoterSignupController < ApplicationController
  def new
  end

  def create
    room = Room.find_by(room_code: params[:room_code])
    return redirect_to new_voter_signup_path if room.nil?

    voter = Voter.create(room: room, nickname: params[:nickname])
    redirect_to room_path(room)
  end
end
