class AddAttachmentToMessages < ActiveRecord::Migration
  def self.up
    add_attachment :messages, :attachment
  end

  def self.down
    remove_attachment :messages, :attachment
  end
end
