class CreateRemoteSessions < ActiveRecord::Migration
  def change
    create_table :remote_sessions do |t|
      t.string :token
      t.timestamp :token_expires
      t.string :refresh_token
      t.belongs_to :remote_user
      t.timestamps null: false
    end
  end
end
