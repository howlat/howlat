class AddDataToIdentities < ActiveRecord::Migration
  def change
    change_table :identities do |t|
      t.string :name
      t.string :email, index: true
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :avatar
    end
  end
end
