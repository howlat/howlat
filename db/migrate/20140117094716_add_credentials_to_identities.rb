class AddCredentialsToIdentities < ActiveRecord::Migration
  def change
    change_table :identities do |t|
      t.string :access_token
      t.string :secret_token
    end
  end
end
