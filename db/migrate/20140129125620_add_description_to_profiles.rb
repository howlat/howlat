class AddDescriptionToProfiles < ActiveRecord::Migration
  def change
    change_table :profiles do |t|
      t.string :description
    end
  end
end
