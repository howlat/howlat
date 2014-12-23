class AddRoomHiddenToRoomMemberships < ActiveRecord::Migration
  def change
    change_table :room_memberships do |t|
      t.boolean :room_hidden, index: true, default: false
    end
  end
end
