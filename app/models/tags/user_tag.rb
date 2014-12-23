class Tags::UserTag < Tag

  PREFIX = 'user'
  REGEXP = /(?<=^|(?<=[^a-zA-Z0-9\-\.]))@([A-Za-z0-9]+[\-\_A-Za-z0-9]*)/
  EVERYONE_KEYS = %w(all everyone everybody)

  def to_label
    "@#{username}"
  end

  def user_id
    return 'everyone' if everyone?
    @user_id ||= name.scan(/\d+/).first.to_i
  end

  def user
    return 'everyone' if everyone?
    @user ||= User.select(:name).find(id: user_id)
  end

  def username
    return 'everyone' if everyone?
    user.name
  end

  def everyone?
    @everyone ||= (self.name =~ /user:everyone/)
  end

end
