class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.references :room, index: true
      t.string :title

      t.timestamps
    end
  end
end
