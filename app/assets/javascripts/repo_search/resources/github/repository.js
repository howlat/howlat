repoSearch.factory('GithubRepository', function($resource) {
  return $resource('/api/v1/github/repositories/:action.json', { }, {
    starred: { params: {action: 'starred'}, method: 'GET', isArray: true },
    private: { params: {action: 'private'}, method: 'GET', isArray: true },
    public: { params: {action: 'public'}, method: 'GET', isArray: true },
    search: { params: {action: 'search'}, method: 'GET', isArray: false }
  });
});
