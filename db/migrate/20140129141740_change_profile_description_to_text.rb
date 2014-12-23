class ChangeProfileDescriptionToText < ActiveRecord::Migration
  def change
    change_column :identities, :description, :text
    change_column :profiles, :description, :text
  end
end
