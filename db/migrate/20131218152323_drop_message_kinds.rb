class DropMessageKinds < ActiveRecord::Migration
  def change
    reversible do |dir|
      drop_table :message_kinds
      dir.up { Message.where(type: nil).update_all(type: 'chat') }
    end
  end
end
