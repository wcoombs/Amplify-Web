class CreateHosts < ActiveRecord::Migration[5.1]
  def change
    create_table :hosts do |t|
      t.string "email"
      t.string "api_token"

      t.timestamps
    end
  end
end
