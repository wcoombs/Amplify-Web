class CreateHosts < ActiveRecord::Migration[5.1]
  def change
    create_table :hosts do |t|
      t.string "email"
      t.string "api_token"

      t.timestamps
    end

    add_column :rooms, :host_id, :integer
    add_index :rooms, :host_id
  end
end
