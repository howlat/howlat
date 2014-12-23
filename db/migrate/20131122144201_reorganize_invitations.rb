class ReorganizeInvitations < ActiveRecord::Migration
  def change

    create_table :rooms_users do |t|
      t.references :user, null: false
      t.references :room, null: false
      t.index [:user_id, :room_id], unique: true
    end

    reversible do |dir|
      dir.up {
        Invitation.transaction do
          Invitation.pluck(:user_id, :room_id).each do |pair|
            user = User.where(id: pair.first).first
            room = Room.where(id: pair.last).first
            if user && room
              puts "Migrating room membership for #{user.email} and room #{room.name}"
              begin
                user.rooms << room
              rescue ActiveRecord::RecordInvalid
                puts "#{user.email} has already access to room #{room.name}"
              end
            end
          end
        end
      }
    end

    remove_column :invitations, :user_id, :integer
    remove_column :invitations, :accepted, :boolean
    rename_column :invitations, :invitation_token, :token

  end
end
