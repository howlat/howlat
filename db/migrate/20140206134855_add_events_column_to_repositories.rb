class AddEventsColumnToRepositories < ActiveRecord::Migration
  def change
    change_table :repositories do |t|
      t.string :events, array: true, default: []
    end
  end
end
