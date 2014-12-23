class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :room, index: true
      t.references :parent, index: true
      t.references :kind, index: true
      t.references :author, index: true
      t.string :author_name, default: '', null: false
      t.text :body
      t.timestamps
    end
  end
end
