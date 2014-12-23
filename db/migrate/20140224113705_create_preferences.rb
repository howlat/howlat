class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.belongs_to :user, index: true
      t.integer :audio_volume, default: 100, length: 3
      t.string :audio_notification
      t.string :desktop_notification
      t.boolean :email_notification, default: false

      t.timestamps
    end

    Preferences.reset_column_information

    reversible do |dir|
      dir.up do
        User.transaction do
          User.find_in_batches(batch_size: 100) do |batch|
            batch.each { |user| user.create_preferences! }
          end
        end
      end
    end

  end
end
