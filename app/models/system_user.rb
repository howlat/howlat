class SystemUser
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::AttributeMethods
  include Profilable

  attr_accessor :id, :name, :email, :profile, :last_activity_at, :updated_at

  def attributes
    {
      'id' => @id,
      'name' => @name,
      'email' => @email,
      'last_activity_at' => @last_activity_at,
      'updated_at' => Time.new(2013, 2, 27, 12, 0, 0)
    }
  end

  def initialize(attributes = {})
    super
    @id = nil
    @name ||= 'howlat'
    @email ||= "#{@name}@howlat.me"
    @last_activity_at ||= Time.zone.now
    @profile ||= Profile.new(name: @name, email: @email)
    freeze
    @profile.readonly!
    @profile.freeze
  end

  def jid
    "#{name.downcase}@#{ENV['XMPP_DOMAIN']}"
  end

  def cache_key
    "system_user/#{jid}"
  end

end
