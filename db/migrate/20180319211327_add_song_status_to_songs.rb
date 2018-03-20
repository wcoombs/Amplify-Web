class AddSongStatusToSongs < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
    CREATE TYPE song_status AS ENUM ('currently_playing', 'up_next', 'votable');
    SQL
    add_column :songs, :song_status, :song_status
  end

  def down
    remove_column :songs, :song_status
    execute <<-SQL
    DROP TYPE song_status;
    SQL
  end
end
