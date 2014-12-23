class RemoveStateFromRepositories < ActiveRecord::Migration
  def change
    change_table :repositories do |t|
      t.remove :state
    end
  end
end
