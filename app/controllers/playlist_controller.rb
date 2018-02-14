class PlaylistController < ApplicationController
  helper_method :has_voted

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

  def has_voted(song_id)
    @vote = Vote.where("song_id = ? AND voter_id = ?", song_id, session[:voter_id]).limit(1).pluck(:score)[0]
  end


end
