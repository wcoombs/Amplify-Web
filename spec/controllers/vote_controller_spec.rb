require 'rails_helper'

RSpec.describe VoteController, type: :controller do
  let(:voter_a) { voters(:voter_a) }
  let(:room_b) { rooms(:room_b) }
  let(:song_b) { songs(:song_b) }


  it "doesn't allow people to vote on songs outside of their room" do
    expect do
      process(:update, params: { playlist_id: room_b.id, id: song_b.id }, session: { voter_id: voter_a.id }, xhr: true)
    end.to_not change { Vote.count }
  end
end
