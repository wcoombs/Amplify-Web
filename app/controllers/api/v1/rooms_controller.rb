module Api
  module V1
    class RoomsController < Api::V1::BaseController
      include Data_Generator
      include Mapping

      def create
        return render json: { error: "Room limit reached!" }, status: :bad_request if @host.room.present?

        new_room = Room.new(room_code: SecureRandom.random_number(8999) + 1000, host: @host)
        while !new_room.save
          new_room.room_code = SecureRandom.random_number(8999) + 1000
        end

        add_songs(new_room.id)

        voter = Voter.create(room: new_room, nickname: 'host')
        @host.update(voters_id: voter.id)


        respond_to do |format|
          format.json { render json: { id: new_room.id, room_code: new_room.room_code, voter_id: voter.id }, status: :ok }
          format.html { head :forbidden }
        end
      end

      def index
        respond_to do |format|
          format.json { render json: { id: @host.room&.id, room_code: @host.room&.room_code, voter_id: @host.voters_id}, status: :ok }
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

      def show
        voter = Voter.find_by_id(@host.voters_id)
        @playlist_data = playlist_data(@host.room.songs, voter).sort_by{|s| -s[:total_score]}
        respond_to do |format|
          format.json { render json: { playlist: @playlist_data }, status: :ok }
          format.html {}
        end
      end
    end
  end
end
