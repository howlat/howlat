class AddAvatarProviderToProfile < ActiveRecord::Migration
  def change
    change_table :profiles do |t|
      t.references :avatar_provider, null: true, default: nil, index: true
    end
  end
end
