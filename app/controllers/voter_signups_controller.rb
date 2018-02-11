class VoterSignupsController < ApplicationController
  def new
  end

  def create
    room = Room.find_by(room_code: params[:room_code])
    if room.nil?
      flash[:room_notice] = "Ooops, no room matches that code."
      render :action => :new
    else
      voter = Voter.create(room: room, nickname: params[:nickname])
      session[:voter_id] = voter.id
      redirect_to playlist_path(room)
    end
  end
end
