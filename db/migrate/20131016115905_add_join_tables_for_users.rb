class AddJoinTablesForUsers < ActiveRecord::Migration
  def change
  	create_table :rooms_users, {:id => false } do |t|
      t.column :room_id, :integer
      t.column :user_id, :integer
    end
    create_table :organizations_users, {:id => false } do |t|
      t.column :organization_id, :integer
      t.column :user_id, :integer
    end
  end
end
