class AddLockedInToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :locked_in, :boolean, default: false
  end
end
