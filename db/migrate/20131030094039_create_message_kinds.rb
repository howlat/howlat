class CreateMessageKinds < ActiveRecord::Migration
  def change
    create_table :message_kinds do |t|
      t.string :name, null: false
    end
    add_index :message_kinds, :name, unique: true
  end
end
