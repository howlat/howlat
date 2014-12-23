class MoveTagsToSeparatedTable < ActiveRecord::Migration
  def change

    create_table :tags do |t|
      t.string :name, null: false
      t.string :type, null: false, index: true
      t.index :name, unique: true
    end

    create_table :taggings do |t|
      t.references :message, null: false
      t.references :tag, null: false

      t.index [:message_id, :tag_id], unique: true
      t.index :tag_id
    end

  end
end
