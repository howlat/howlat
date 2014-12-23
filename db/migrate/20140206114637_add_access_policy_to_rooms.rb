class AddAccessPolicyToRooms < ActiveRecord::Migration
  def change
    change_table :rooms do |t|
      t.string :access_policy, index: true
    end

    reversible do |dir|
      dir.up { Room.joins(:repository).update_all(access_policy: "github") }
    end
  end
end
