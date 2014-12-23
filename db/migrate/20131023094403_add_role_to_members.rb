class AddRoleToMembers < ActiveRecord::Migration
  def change
    add_column :members, :role, :string, default: 'member'
  end
end
