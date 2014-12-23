class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.belongs_to :room, index: true, null: false
      t.json :config
      t.string :type, null: false

      t.timestamps
    end
    add_index :integrations, :type
  end
end
