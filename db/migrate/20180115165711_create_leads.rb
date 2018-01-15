class CreateLeads < ActiveRecord::Migration[5.1]
  def change
    create_table :leads do |t|
      t.string "email"
      t.string "referrer"

      t.timestamps
    end
  end
end
