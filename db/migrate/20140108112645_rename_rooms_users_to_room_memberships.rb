class RenameRoomsUsersToRoomMemberships < ActiveRecord::Migration
  def change
    rename_table :rooms_users, :room_memberships
  end
end
