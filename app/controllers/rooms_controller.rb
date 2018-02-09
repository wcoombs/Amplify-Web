class RoomsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    respond_to do |format|
      format.json { render json: { room_code: "ola" }, status: :ok }
      format.html { head :forbidden }
    end
  end
end
