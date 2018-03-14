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
        @host.update(voter: voter)

        respond_to do |format|
          format.json { render json: { id: new_room.id, room_code: new_room.room_code, voter_id: @host.voter&.id }, status: :ok }
          format.html { head :forbidden }
        end
      end

      def index
        respond_to do |format|
          format.json { render json: { id: @host.room&.id, room_code: @host.room&.room_code, voter_id: @host.voter&.id}, status: :ok }
          format.html { head :forbidden }
        end
      end

      def destroy
        room = Room.find(params[:id])
        return unless check_room_id!(room)
        room.destroy

        respond_to do |format|
          format.json { render json: { }, status: :ok }
          format.html { head :forbidden }
        end
      end

      def show
        voter = Voter.find_by_id(@host.voter)

        @playlist_data = playlist_data(@host.room.songs.where(song_status_id: 3), voter).sort_by{|s| -s[:total_score]}
        respond_to do |format|
          format.json { render json: { playlist: @playlist_data }, status: :ok }
          format.html {}
        end
      end

      def next_song
        room = Room.find_by_id(params[:room_id])
        return unless check_room_id!(room)

        songs = room.songs
        played = songs.find_by(song_status_id: 1)
        curr = songs.find_by(song_status_id: 2)
        up_next = songs.left_outer_joins(:votes).where(song_status_id: 3).group(:id).order('sum(votes.score) desc').first
        if played
          Song.destroy(played.id)
        end
        if curr
          curr.update(song_status_id: 1)
        end
        if up_next
          up_next.update(song_status_id: 2)
        end

        respond_to do |format|
          format.json { render json: {current: curr, next_song: up_next}, status: :ok }
          format.html {}
        end
      end

      private

      def check_room_id!(room)
        unless @host.room == room
          respond_to do |format|
            format.html { redirect_to(root_url) }
            format.json { render json: { error: 'This aint your room buddy' }, status: :unauthorized }
          end
          return false
        end
        true
      end
    end
  end
end
