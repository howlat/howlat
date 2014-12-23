class AddTitleFieldToMember < ActiveRecord::Migration
  def change
  	add_column :members, :title, :string, :default => ''
  end
end
