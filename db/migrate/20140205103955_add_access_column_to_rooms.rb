class AddAccessColumnToRooms < ActiveRecord::Migration
  def change
    change_table :rooms do |t|
      t.string :access, nil: false, index: true
    end
  end
end
