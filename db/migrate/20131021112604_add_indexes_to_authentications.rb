class AddIndexesToAuthentications < ActiveRecord::Migration
  def change
    add_index :authentications, [:user_id, :provider, :uid]
  end
end
