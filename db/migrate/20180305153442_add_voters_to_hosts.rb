class AddVotersToHosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :voters, :host, index: true
  end
end
