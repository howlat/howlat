class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.belongs_to :account
      t.string :name
      t.string :email
      t.string :location
      t.string :company
      t.string :website
      t.attachment :avatar
      t.timestamps
      t.index :account_id, unique: true
    end
  end
end
