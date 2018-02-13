class AddArtistToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :artist, :string
  end
end
