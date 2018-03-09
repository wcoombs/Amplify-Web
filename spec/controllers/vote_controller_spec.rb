require 'rails_helper'

RSpec.describe VoteController, type: :controller do
  let(:voter_a) { voters(:voter_a) }
  let(:room_a) { rooms(:room_a) }
  let(:room_b) { rooms(:room_b) }
  let(:song_a) { songs(:song_a) }
  let(:song_a2) { songs(:song_a2) }
  let(:song_b) { songs(:song_b) }
  let(:vote_a) { votes(:vote_a) }

  it "doesn't allow people vote greater than 1" do
    expect do
      process(:update, params: { playlist_id: room_a.id, id: song_a2.id, vote: 1000 }, session: { voter_id: voter_a.id }, xhr: true)
    end.to change { Vote.count }.by(1)
    expect(song_a2.votes.sum(:score)).to eq(1)
  end

  it "doesn't allow people to vote less than -1" do
    expect do
      process(:update, params: { playlist_id: room_a.id, id: song_a2.id, vote: -1000 }, session: { voter_id: voter_a.id }, xhr: true)
    end.to change { Vote.count }.by(1)
    expect(song_a2.votes.sum(:score)).to eq(-1)
  end

  it "doesn't allow people to vote on songs outside of their room" do
    expect do
      process(:update, params: { playlist_id: room_b.id, id: song_b.id }, session: { voter_id: voter_a.id }, xhr: true)
    end.to_not change { Vote.count }
  end

  it "allows people to vote on songs in their room" do
    expect do
      process(:update, params: { playlist_id: room_a.id, id: song_a2.id }, session: { voter_id: voter_a.id }, xhr: true)
    end.to change { Vote.count }.by(1)
  end

  it "revoting updates the vote and doesn't create a new one" do

    expect do
      process(:update, params: { playlist_id: room_a.id, id: song_a.id, vote: 0 }, session: { voter_id: voter_a.id }, xhr: true)
    end.to_not change { Vote.count }

    expect(vote_a.score).to eq(0)
  end
end
