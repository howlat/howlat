class ChangeMessage < ActiveRecord::Migration
  def change
    change_column :messages, :author_id, :integer, index: true, null: false
    remove_column :messages, :author_name
  end
end
