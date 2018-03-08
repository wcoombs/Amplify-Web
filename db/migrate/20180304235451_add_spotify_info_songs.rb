class AddSpotifyInfoSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :duration, :bigint
    add_column :songs, :uri, :string
  end
end
