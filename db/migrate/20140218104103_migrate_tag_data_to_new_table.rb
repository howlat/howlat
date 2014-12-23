class MigrateTagDataToNewTable < ActiveRecord::Migration
  def up
    Message.transaction do
      Message.select('id', 'tags as raw_tags').find_in_batches(batch_size: 500) do |group|
        group.each do |message|
          m = Message.find(message.id)
          message.raw_tags.each do |raw_tag|
            m.tags.add(raw_tag)
          end
          m.save!
          puts "Message #{m.id} migrated"
        end
      end
    end

    remove_column :messages, :tags
  end
end
