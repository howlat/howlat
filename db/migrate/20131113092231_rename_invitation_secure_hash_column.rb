class RenameInvitationSecureHashColumn < ActiveRecord::Migration
  def change
    rename_column :invitations, :secure_hash, :invitation_token
  end
end
