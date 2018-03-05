module Api
  module V1
    class RoomsController < Api::V1::BaseController
      include Data_Generator
      include Mapping

      require 'json'

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
        Room.find(params[:id]).destroy

        respond_to do |format|
          format.json { render json: { }, status: :ok }
          format.html { head :forbidden }
        end
      end

      def show
        voter = Voter.find_by_id(@host.voter)
        @playlist_data = playlist_data(@host.room.songs, voter).sort_by{|s| -s[:total_score]}
        respond_to do |format|
          format.json { render json: { playlist: @playlist_data }, status: :ok }
          format.html {}
        end
      end

      def next_song
        room = Room.find_by_id(params[:playlist_id])

        max_score_song = room.songs[0]
        max_score = max_score_song.votes.sum(:score)
        locked_in_song = room.songs[0]
        room.songs.each do |song|
          if song.locked_in
            locked_in_song = song
          else
            curr_score = song.votes.sum(:score)
            if curr_score > max_score
              max_score = curr_score
              max_score_song = song
            end
          end
        end

        # return song locked_in=1
        # and song with max votes and locked_in=0
        # return song objects, not just ID's

        [locked_in_song, max_score_song].to_json
      end
    end
  end
end
