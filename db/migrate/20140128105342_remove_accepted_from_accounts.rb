class RemoveAcceptedFromAccounts < ActiveRecord::Migration
  def change
    change_table :accounts do |t|
      t.remove :accepted
    end
  end
end
