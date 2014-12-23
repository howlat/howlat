class Profile < ActiveRecord::Base

  alias_attribute :full_name, :name
  alias_attribute :fullname, :name
  alias_attribute :url, :website

  belongs_to :avatar_provider, class_name: 'Identity'
  belongs_to :account, touch: true

  has_attached_file :avatar,
    default_url: ":default_avatar_url",
    styles: {
      medium: '150x150#',
      small: '75x75#',
      thumb: '40x40#'
    }

  validates :avatar_provider_id,
    inclusion: { in: ->(profile) { profile.account.identity_ids } },
    allow_nil: true
  validates_attachment :avatar,
    content_type: { content_type: %w(image/jpg image/jpeg image/png) }

  before_save :strip_attributes!


  def avatar_providers
    account.identities
  end

  def reset_avatar=(value)
    update(avatar: nil, avatar_provider_id: nil) if value.to_i == 1
  end

  def gravatar_url(size)
    Gravatar.new(email).url(size: size)
  end

  def default_avatar_url(size)
    if avatar_provider_id?
      avatar_provider.avatar_url(size)
    else
      gravatar_url(size)
    end
  end

  private

  def strip_attributes!
    [self.name, self.email].map! { |field| field.strip! if field }
  end

end
