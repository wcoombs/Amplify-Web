module Api
  module V1
    class VoteController < Api::V1::BaseController
      include Voting

      def update
        voter = @host.voter

        song = Song.find(params[:id])
        unless song.room_id == voter.room_id
          return render json: { error: "forbidden resource" }, status: :forbidden
        end

        add_vote(voter, params[:vote].to_i, song)

        render json: { new_score: song.votes.sum(:score) }, status: :ok
      end
    end
  end
end