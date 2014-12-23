class NewBusinessModel < ActiveRecord::Migration
  def change
    change_table :rooms do |t|
      t.rename :organization_id, :owner_id
    end

    drop_table :members
    drop_table :organizations
    drop_table :integrations

    rename_table :users, :accounts

    change_table :accounts do |t|
      t.remove :first_name
      t.remove :last_name
      t.remove :avatar_file_name
      t.remove :avatar_content_type
      t.remove :avatar_file_size
      t.remove :avatar_updated_at
      t.string :type, index: true
      t.index :name, unique: true
    end

    create_table :organization_memberships do |t|
      t.references :user
      t.references :organization, index: true
      t.index [:user_id, :organization_id], unique: true
    end
  end
end
