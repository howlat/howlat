class AddEmailFieldToInvitation < ActiveRecord::Migration
  def change
    change_table :invitations do |t|
      t.string :email
    end
  end
end
