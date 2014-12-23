class PreferencesUserIdNotNull < ActiveRecord::Migration
  def up
    change_column_null :preferences, :user_id, false
  end

  def down
    change_column_null :preferences, :user_id, true
  end
end
