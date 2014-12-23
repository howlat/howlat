class AddTokenColumnToRooms < ActiveRecord::Migration
  def change
    change_table :rooms do |t|
      t.string :token, nil: false
      t.index :token, unique: true
    end
  end
end
