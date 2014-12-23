class AddEditedAtToMessages < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.timestamp :edited_at, null: true, default: nil
    end
  end
end
