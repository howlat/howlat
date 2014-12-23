class Identities::Google < Identity

  private

  def convert_oauth_data(data)
    data[:info][:nickname] ||= data[:info][:email]
    super(data)
  end
end
