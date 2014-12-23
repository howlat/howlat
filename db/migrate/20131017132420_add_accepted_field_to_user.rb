class AddAcceptedFieldToUser < ActiveRecord::Migration
  def change
  	add_column :users, :accepted, :boolean, :default => false
	add_index :users, :accepted
  end
end
