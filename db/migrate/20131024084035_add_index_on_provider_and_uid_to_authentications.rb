class AddIndexOnProviderAndUidToAuthentications < ActiveRecord::Migration
  def change
    add_index :authentications, [:uid, :provider], unique: true
  end
end
