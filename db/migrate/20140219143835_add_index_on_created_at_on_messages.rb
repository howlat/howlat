class AddIndexOnCreatedAtOnMessages < ActiveRecord::Migration
  def change
    add_index :messages, :created_at
  end
end
