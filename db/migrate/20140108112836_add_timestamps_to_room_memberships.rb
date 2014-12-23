class AddTimestampsToRoomMemberships < ActiveRecord::Migration
  def change
    change_table :room_memberships do |t|
      t.timestamps
    end
  end
end
