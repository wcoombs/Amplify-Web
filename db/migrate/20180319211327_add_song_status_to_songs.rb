class AddSongStatusToSongs < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
    CREATE TYPE song_status AS ENUM ('currently_playing', 'up_next', 'votable');
    SQL
    add_column :songs, :song_status, :song_status, default: 'votable'
  end
end
