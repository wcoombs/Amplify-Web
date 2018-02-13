class PlaylistController < ApplicationController
  def show
    @room = Room.find_by_id(params[:id])
    unless @room.present?
      flash[:error] = "That room does not exist."
      return redirect_to root_path
    end

    voter = @room.voters.select { |v| v.id == session[:voter_id] }
    unless voter.present?
      flash[:error] = "You must create a user to join this room."
      return redirect_to root_path
    end
  end
end
