class ChangeMembersRoleColumn < ActiveRecord::Migration
  def self.up
    id_to_role = Member.pluck("id, role")

    change_table :members do |t|
      t.remove :role
      t.integer :role_id, index: true
    end

    Member.reset_column_information

    Member.transaction do
      id_to_role.each do |data|
        member = Member.find(data[0])
        member.role_id = Role.find_by_name(data[1]).id rescue nil
        member.save
      end
    end

  end

  def self.down
    id_to_role_id = Member.pluck("id, role_id")

    change_table :members do |t|
      t.remove :role_id
      t.string :role, index: true
    end

    Member.reset_column_information

    Member.transaction do
      id_to_role_id.each do |data|
        member = Member.find(data[0])
        member.role = Role.find(data[1]).name rescue nil
        member.save
      end
    end

  end
end
