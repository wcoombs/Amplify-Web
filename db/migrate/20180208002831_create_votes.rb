class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.references :song, index: true
      t.references :voter, index: true
      t.integer :score

      t.timestamps
    end
  end
end
