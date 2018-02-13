class RoomsController < ApplicationController
  include Data_Generator
  skip_before_action :verify_authenticity_token


  def create
    new_room = Room.create(room_code: SecureRandom.hex(2).upcase)
    add_songs(new_room.id)

    respond_to do |format|
      format.json { render json: { id: new_room.id, room_code: new_room.room_code }, status: :ok }
      format.html { head :forbidden }
    end
  end

  def destroy
    Room.find(params[:id]).destroy

    respond_to do |format|
      format.json { render json: { }, status: :ok }
      format.html { head :forbidden }
    end
  end

end
