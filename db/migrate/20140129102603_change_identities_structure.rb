class ChangeIdentitiesStructure < ActiveRecord::Migration
  def change
    change_table :identities do |t|
      t.string :description
      t.string :location
      t.column :urls, :json
    end
  end
end
