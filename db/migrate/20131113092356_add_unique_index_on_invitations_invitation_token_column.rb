class AddUniqueIndexOnInvitationsInvitationTokenColumn < ActiveRecord::Migration
  def change
    add_index :invitations, :invitation_token, unique: true
  end
end
