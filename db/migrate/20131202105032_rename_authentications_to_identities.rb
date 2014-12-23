class RenameAuthenticationsToIdentities < ActiveRecord::Migration
  def change
    rename_table :authentications, :identities
  end
end
