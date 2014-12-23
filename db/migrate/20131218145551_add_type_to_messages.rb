class AddTypeToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :type, :string, index: true
  end
end
