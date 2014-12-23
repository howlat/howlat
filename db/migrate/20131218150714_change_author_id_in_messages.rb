class ChangeAuthorIdInMessages < ActiveRecord::Migration
  def change
    change_column :messages, :author_id, :integer, null: true, index: true
  end
end
