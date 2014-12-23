class AddPasswordSetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_set, :boolean, default: true
  end
end
