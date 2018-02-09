class CreateVoters < ActiveRecord::Migration[5.1]
  def change
    create_table :voters do |t|
      t.references :room, index: true
      t.string :nickname

      t.timestamps
    end
  end
end
