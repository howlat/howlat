class RemoveMessageKindFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :kind_id, :integer, null: false, index: true
  end
end
