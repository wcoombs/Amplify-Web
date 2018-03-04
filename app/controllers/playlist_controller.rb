class PlaylistController < ApplicationController
  include Mapping

  def show
    @room = Room.find_by_id(params[:id])
    unless @room.present?
      flash[:error] = "That room does not exist."
      return redirect_to root_path
    end

    voter = @room.voters.detect { |v| v.id == session[:voter_id] }
    unless voter.present?
      flash[:error] = "You must create a user to join this room."
      return redirect_to root_path
    end
    @playlist_data = playlist_data(@room.songs, voter).sort_by{|s| -s[:total_score]}
    respond_to do |format|
      format.json { render json: { playlist: @playlist_data }, status: :ok }
      format.html {}
    end
  end
end
