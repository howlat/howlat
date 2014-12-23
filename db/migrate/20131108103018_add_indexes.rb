class AddIndexes < ActiveRecord::Migration
  def change
    add_index :invitations, [:user_id, :room_id, :accepted], unique: true
    add_index :members, [:organization_id, :user_id], unique: true
    add_index :members, [:organization_id, :user_id, :role_id], unique: true
    add_index :organizations, :name, unique: true
    add_index :rooms, [:organization_id, :name], unique: true
  end
end
