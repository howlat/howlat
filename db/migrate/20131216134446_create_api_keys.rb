class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :token, null: false
      t.string :type, null: false, index: true
      t.references :room, index: true, null: true
      t.references :user, index: true, null: true
      t.index :token, unique: true
    end

    remove_column :rooms, :token, :string

    reversible do |dir|
      dir.up {
        ActiveRecord::Base.transaction do
          User.all.map(&:create_api_key)
          Room.all.map(&:create_api_key)
        end
      }
    end

  end
end
