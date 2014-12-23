class Identity < ActiveRecord::Base
  self.inheritance_column = 'provider'
  include Inheritable::Sti

  TYPES = {
    bitbucket: 'Identities::Bitbucket',
    facebook: 'Identities::Facebook',
    github: 'Identities::Github',
    google_oauth2: 'Identities::Google',
    twitter: 'Identities::Twitter'
  }.freeze
  PROVIDERS = TYPES.keys.map(&:to_s)

  act_as_sti(TYPES)

  belongs_to :user, inverse_of: :identities, touch: true

  validates :user_id, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  alias_attribute :image, :avatar
  alias_method :connected?, :persisted?

  def self.supported
    @@supported = PROVIDERS.map { |provider| new(provider: provider) }
  end

  def from_oauth(data = {})
    data[:info] ||= {}
    converted_data = convert_oauth_data(data).delete_if { |k, v| v.blank? }
    assign_attributes(converted_data)
    self
  end

  def provider_name
    self.class.model_name.human
  end

  def avatar_url(size)
    Gravatar.new(self.email).url(size: size)
  end

  def to_profile
    Profile.new(account: self.user, email: self.email, name: self.name, location: self.location,
      avatar: nil, avatar_provider: self, website: self.urls.try(:values).try(:first))
  end

  def to_user
    User.new(email: self.email, name: self.nickname) do |u|
      u.password = Generators::RandomPassword.new.generate
      u.password_set = false
    end
  end

  private

  def convert_oauth_data(data)
    new_data = data.slice(:uid, :provider)
    new_data.merge!(data[:info].slice(:first_name, :last_name, :nickname,
      :name, :email, :image, :avatar, :description, :urls))
    if data[:credentials].present?
      new_data[:access_token] = data[:credentials][:token]
      new_data[:secret_token] = data[:credentials][:secret]
    end
    new_data
  end

end
