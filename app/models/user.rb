class User < Account
  include ApiKeyable
  api_keyable 'PersonalApiKey'

  authenticates_with_sorcery!

  has_many :identities, dependent: :destroy
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_many :rooms, through: :room_memberships, uniq: true do
    def leave(*room_ids)
      proxy_association.owner
        .room_memberships.where(room_id: room_ids).destroy_all
    end

    def hide(*room_ids)
      proxy_association.owner
        .room_memberships.where(room_id: room_ids).update_all(room_hidden: true)
    end

    def unhide(*room_ids)
      proxy_association.owner
        .room_memberships.where(room_id: room_ids).update_all(room_hidden: false)
    end

    def visible
      where(room_memberships: { room_hidden: false })
    end
  end
  has_many :room_memberships, uniq: true, inverse_of: :user
  has_many :messages, foreign_key: 'author_id'
  has_one :preferences, inverse_of: :user

  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 4, if: :'password.present?'

  before_save :update_password_set_field
  after_update :update_timestamp_of_authored_messages
  after_create { create_preferences }


  def self.without_email_notification
    joins(:preferences).where(preferences: {email_notification: false})
  end

  def cached_github_identity
    key = "#{cache_key}/github_identity"
    Rails.cache.fetch(key) { identities.github.first }
  end

  private

  def update_timestamp_of_authored_messages
    messages.update_all(updated_at: current_time_from_proper_timezone)
  end

  def update_password_set_field
    self.password_set = true if password.present? && persisted?
  end

end
