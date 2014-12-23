class AddSlugToOrganizationsAndRooms < ActiveRecord::Migration
  def change

    add_column :organizations, :slug, :string
    add_column :rooms, :slug, :string

    Organization.all.each do |o|
      o.generate_slug.save
    end

    Room.all.each do |o|
      o.generate_slug.save
    end

    change_column :organizations, :slug, :string, null: false
    change_column :rooms, :slug, :string, null: false
    add_index :organizations, :slug, unique: true
    add_index :rooms, [:organization_id, :slug], unique: true
  end
end
