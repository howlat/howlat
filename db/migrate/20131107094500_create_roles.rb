class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
    end
    add_index :roles, :name, unique: true

    ['member', 'owner', 'admin'].each do |name|
      Role.where(name: name).first_or_create!
    end

  end
end
