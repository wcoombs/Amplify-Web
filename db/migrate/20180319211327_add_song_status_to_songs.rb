class AddSongStatusToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :song_status, :string, default: 'votable'
  end
end
