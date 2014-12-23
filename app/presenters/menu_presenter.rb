class MenuPresenter < BasePresenter
  presents :menu

  def rooms
    @rooms ||= Room
      .includes(:owner, :repository)
      .accessible_by(current_ability)
      .order(created_at: :asc).uniq
  end

  def link_to(text, url, options = {})
    link_class = 'list-group-item'
    link_class << (h.current_page?(url) ? ' active' : '')
    h.link_to text, url, class: link_class
  end

  def cache_key
    "menu/v1.1/"
  end

end
