class AddRoomIdToInvitation < ActiveRecord::Migration
  def change
  	add_column :invitations, :room_id, :integer, :default => nil
	add_index :invitations, :room_id
  end
end
