class RoomsController < ApplicationController
  include Data_Generator
  skip_before_action :verify_authenticity_token


  def create
    new_room = Room.new
    new_room.room_code = SecureRandom.hex(2).upcase
    new_room.save
    add_songs(new_room.id)

    respond_to do |format|
      format.json { render json: { room_code: new_room.room_code }, status: :ok }
      format.html { head :forbidden }
    end
  end
end
