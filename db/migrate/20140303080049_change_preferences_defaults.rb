class ChangePreferencesDefaults < ActiveRecord::Migration
  def up
    change_column_default :preferences, :email_notification, true
    change_column_default :preferences, :audio_notification, 'mentions'
    change_column_default :preferences, :desktop_notification, 'mentions'

    User.transaction do
      User.find_in_batches(batch_size: 100) do |batch|
        batch.each do |user|
          user.preferences.update(email_notification: true,
            audio_notification: 'mentions', desktop_notification: 'mentions')
        end
      end
    end
  end

  def down
    change_column_default :preferences, :email_notification, false
    change_column_default :preferences, :audio_notification, 'all'
    change_column_default :preferences, :desktop_notification, 'all'
  end
end
