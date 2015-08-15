class CreateCallsignInfos < ActiveRecord::Migration
  def change
    create_table :callsign_infos do |t|
      t.string :name
      t.string :stationary_qth
      t.string :stationary_qth_locator
      t.string :current_qth
      t.string :current_qth_locator
      t.belongs_to :remote_user
      t.timestamps null: false
    end
  end
end
