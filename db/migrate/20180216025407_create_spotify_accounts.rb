class CreateSpotifyAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :spotify_accounts do |t|
      t.references :host, index: true
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
