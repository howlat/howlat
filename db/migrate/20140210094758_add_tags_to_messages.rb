class AddTagsToMessages < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.string :tags, array: true, default: '{}'
      t.index :tags, using: 'gin'
    end
  end
end
