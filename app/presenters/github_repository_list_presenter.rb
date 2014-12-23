class GithubRepositoryListPresenter < BasePresenter
  presents :github_repository_list

  def private_repos
    @private_repos ||= github.repositories(nil, type: 'private')
  end

  def public_repos
    @public_repos ||= github.repositories(nil, type: 'public')
  end

  def starred_repos
    @starred_repos ||= github.starred
  end

  def searched_repos
    @searched_repos ||= github
      .search_repositories(query, search_options)
      .try(:items)
  rescue Exception => e
    Rails.logger.debug e.message
    @searched_repos ||= []
  end

  def search_options
    defaults = { per_page: 20, page: 1 }
  end

  def tabs
    ['private', 'public', 'starred', 'search']
  end

  def tab?(tab_name)
    tab.eql?(tab_name)
  end

  def tab_class(tab_name)
    tab?(tab_name) ? 'active' : nil
  end

  def tab
    params[:repositories][:tab] rescue 'private'
  end

  def query
    params[:repositories][:query] rescue nil
  end

  def search_form_options
    { url: nil, method: :get }
  end

  def search_form_key
    :repositories
  end

  def search_form_query_key
    :query
  end

  def search_tab_name
    'search'
  end

  def cache_key_for(tab_name)
    key = [current_user.cache_key, 'github', 'repositories', tab_name]
    key << query << search_options.values if tab_name.eql?('search')
    key
  end

  def cache_options
    { expires_in: 3.minutes }
  end

end
