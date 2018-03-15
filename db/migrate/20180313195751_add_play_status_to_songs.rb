class AddPlayStatusToSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :song_statuses do |t|
      t.string :song_status
    end
    add_reference :songs, :song_status, index: true
    remove_column :songs, :locked_in
  end
end
