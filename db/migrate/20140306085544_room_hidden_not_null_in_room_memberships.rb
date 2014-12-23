class RoomHiddenNotNullInRoomMemberships < ActiveRecord::Migration
  def up
    change_column_null :room_memberships, :room_hidden, false
  end

  def down
    change_column_null :room_memberships, :room_hidden, true
  end
end
