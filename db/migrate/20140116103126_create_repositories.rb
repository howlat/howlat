class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.belongs_to :room
      t.string :name
      t.integer :state, default: 0
      t.string :type, index: true

      t.timestamps

      t.index :room_id, unique: true
    end
  end
end
