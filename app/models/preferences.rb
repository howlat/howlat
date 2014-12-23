class Preferences < ActiveRecord::Base
  extend Enumerize

  enumerize :audio_notification, in: %i(all chat_or_mentions mentions none),
    default: :mentions
  enumerize :desktop_notification, in: %i(all chat_or_mentions mentions none),
    default: :mentions

  belongs_to :user, inverse_of: :preferences

  validates :user_id, presence: true, uniqueness: true
  validates :audio_volume, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

end
