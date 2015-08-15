class CreateRemoteUsers < ActiveRecord::Migration
  def change
    create_table :remote_users do |t|
      t.string :callsign
      t.string :email
      t.timestamps null: false
    end
  end
end
