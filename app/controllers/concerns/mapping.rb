module Mapping
  def playlist_data(songs, voter)
    songs.each.map do |song|
      {
          id: song.id,
          title: song.title,
          artist: song.artist,
          voter_score: song.voter_vote(voter)&.score,
          total_score: song.votes.sum(:score),
          song_status: song.song_status_id
      }
    end
  end

  def song_statuses
    return {currently_playing: SongStatus.where(song_status: "currently_playing").first.id,
                     up_next: SongStatus.where(song_status: "up_next").first.id,
                     votable: SongStatus.where(song_status: "votable").first.id}
  end
end