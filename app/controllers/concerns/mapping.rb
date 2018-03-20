module Mapping
  def playlist_data(songs, voter)
    songs.each.map do |song|
      {
          id: song.id,
          title: song.title,
          artist: song.artist,
          voter_score: song.voter_vote(voter)&.score,
          total_score: song.votes.sum(:score),
          song_status: song.song_status
      }
    end
  end
end