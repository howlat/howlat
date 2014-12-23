class Badge
  include ActiveModel::Model

  attr_accessor :room

  def image
    @path_to_image ||= File.join(Rails.root, 'app', 'assets', 'images', 'github-badge.png')
    @image ||= File.open(@path_to_image, 'rb').read
  end

  def image_url(url_provider)
    url_provider.room_badge_url(room.name, format: :png)
  end

  def room_url(url_provider)
    url_provider.room_friendly_url(room.name)
  end

  def markdown(url_provider)
    "[![Howlat Room](#{image_url(url_provider)})](#{room_url(url_provider)})"
  end

end
