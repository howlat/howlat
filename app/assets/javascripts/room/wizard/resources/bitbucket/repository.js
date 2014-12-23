wizard.factory('BitbucketRepository', function($resource) {
  return $resource('/api/v1/integrations/github/repositories/:action.json', { }, {
    starred: { params: {action: 'starred'}, method: 'GET', isArray: true }
  });
});
