class Gravatar

  def initialize(email)
    @email = email
  end

  def gravatar_id
    @gravatar_id ||= Digest::MD5::hexdigest(@email).downcase
  end

  def url(options = {})
    size = options.fetch(:size, 80)
    "http://www.gravatar.com/avatar/#{gravatar_id}.png?d=mm&s=#{size}"
  end

end
