class Identities::Github < Identity

  def avatar_url(size)
    "#{avatar}&s=#{size.to_i}"
  end

end
