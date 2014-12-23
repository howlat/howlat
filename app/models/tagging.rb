class Tagging < ActiveRecord::Base

  belongs_to :message, inverse_of: :taggings, touch: true
  belongs_to :tag, inverse_of: :taggings

  validates :message_id, presence: true
  validates :tag_id, uniqueness: { scope: :message_id }, presence: true

end
