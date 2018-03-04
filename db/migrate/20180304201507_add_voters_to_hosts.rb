class AddVotersToHosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :hosts, :voters, index: true, foreign_key: true
  end
end
