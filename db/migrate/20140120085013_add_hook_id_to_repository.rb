class AddHookIdToRepository < ActiveRecord::Migration
  def change
    change_table :repositories do |t|
      t.integer :hook_id, null: true
    end
  end
end
