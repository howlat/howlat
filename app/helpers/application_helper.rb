require 'digest/md5'

module ApplicationHelper

  def avatar_for(profile_or_email, size = :thumb, html_options = {})
    profile = profile_or_email.kind_of?(Profile) ? profile_or_email : nil
    email = profile ? profile.email : profile_or_email

    title = profile ? profile.name : email
    url = profile ? avatar_url_for(profile, size) : gravatar_url_for(email)
    return '' unless url
    html_options.stringify_keys!
    width = html_options.fetch('width', width_for(size))
    height = html_options.fetch('height', height_for(size))
    classname = ['avatar', html_options.fetch('class', 'img-rounded')].compact.join(' ')
    alt = title

    image_tag url, class: classname, alt: alt, title: title, width: width, height: height
  end

  def gravatar_url_for(email, size = :thumb)
    return '' unless email
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}.png?d=mm&s=#{width_for(size)}"
  end

  def avatar_url_for(profile, size = :thumb)
    profile.avatar.url(size, escape: false)
  end

  def height_for(size)
    {
      thumb: 40,
      small: 75,
      medium: 150
    }.fetch(size, 40)
  end

  def width_for(size)
    {
      thumb: 40,
      small: 75,
      medium: 150
    }.fetch(size, 40)
  end

  def present(object, options = {})
    name = object.class.eql?(Symbol) ? object.to_s.classify : object.class.name
    klass = options.fetch(:with, "#{name}Presenter".safe_constantize)
    presenter = klass.new(object, self, options)
    yield presenter if block_given?
    presenter
  end

  def alert_class(key)
    case key.to_sym
    when :notice, :success; 'success'
    when :error, :alert; 'danger'
    when :warning; 'warning'
    else 'info'
    end
  end

  def chatapp_asset_url(relative_path_to_asset)
    url, version = CHAT['app_url'], ENV['CHATAPP_VERSION']
    "#{url}#{relative_path_to_asset}?v=#{version}"
  end
  alias_method :chatapp_url, :chatapp_asset_url

end
