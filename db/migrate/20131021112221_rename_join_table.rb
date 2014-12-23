class RenameJoinTable < ActiveRecord::Migration
  def change
  	rename_table :organizations_users, :members
  	add_column :members, :status, :integer, :default => 0
	add_index :members, :status
  end
end
