class ChangeColumnHashinIvitations < ActiveRecord::Migration
  def change
  	rename_column :invitations, :hash, :secure_hash
  end
end
