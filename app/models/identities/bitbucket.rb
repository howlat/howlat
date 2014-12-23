class Identities::Bitbucket < Identity

  def avatar_url(size)
    url = avatar.gsub(/&s=\d*/, "&s=#{size.to_i}")
    url = "#{avatar}&s=#{size.to_i}" unless url
    url
  end

  private

  def convert_oauth_data(data)
    data[:info][:nickname] ||= data[:uid]
    super(data)
  end
end
