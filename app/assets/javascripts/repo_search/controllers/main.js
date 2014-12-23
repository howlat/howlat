repoSearch.controller("MainCtrl", ["$scope", "$timeout", "GithubRepository", function($scope, $timeout, GithubRepository) {
  "use strict";

  $scope.Howlat = Howlat;

  $scope.query = {
    owner: '',
    repo: '',
    scopes: { name: true, description: false, readme: false }
  };
  $scope.repositories = {
    starred:  { items: [] },
    private:  { items: [] },
    public:   { items: [] },
    search:   { items: [], page: 1, per_page: 10, pages: 1 }
  };
  $scope.loading = false;
  $scope.loadingText = 'Loading...';
  $scope.resultSetEmptyText = 'No repositories found.';

  $scope.$watch('repositories.search.page', function(new_val, old_val) {
    if(new_val !== old_val)
      $scope.loadSearchResults();
  });

  var onLoadingStarts = function(){
    $scope.loading = true;
  };

  var onLoadingEnds = function(){
    $scope.loading = false;
  };

  $scope.loadStarredRepos = function() {
    onLoadingStarts();
    var onSuccess = function(repos) {
      $scope.repositories.starred.items = repos;
      onLoadingEnds();
    };
    var onFailure = function(){
      onLoadingEnds();
    };
    GithubRepository.starred({}, onSuccess, onFailure);
  };

  $scope.loadPrivateRepos = function() {
    onLoadingStarts();
    var onSuccess = function(repos) {
      $scope.repositories.private.items = repos;
      onLoadingEnds();
    };
    var onFailure = function(){
      onLoadingEnds();
    };
    GithubRepository.private({}, onSuccess, onFailure);
  };

  $scope.loadPublicRepos = function() {
    onLoadingStarts();
    var onSuccess = function(repos) {
      $scope.repositories.public.items = repos;
      onLoadingEnds();
    };
    var onFailure = function(){
      onLoadingEnds();
    };
    GithubRepository.public({}, onSuccess, onFailure);
  };

  $scope.loadSearchResults = function() {
    onLoadingStarts();
    var page = $scope.repositories.search.page;
    var per_page = $scope.repositories.search.per_page;
    var onSuccess = function(data) {
      $scope.repositories.search.items = data.items;
      $scope.repositories.search.total = data.total_count;
      $scope.repositories.search.pages = Math.ceil(data.total_count/per_page);
      if($scope.repositories.search.pages < 1)
        $scope.repositories.search.pages = 1;
      onLoadingEnds();
    };
    var onFailure = function() { onLoadingEnds(); };
    var params = { query: getQuery(), page: page, order: 'desc', sort: 'stars' }

    GithubRepository.search(params, onSuccess, onFailure);
  };

  var getQuery = function() {
    var owner = $scope.query.owner;
    var repo = $scope.query.repo;
    var searchScopes = [];
    for (var key in $scope.query.scopes) {
      if($scope.query.scopes[key])
        searchScopes.push(key);
    }
    var q = repo;
    if(owner && owner.length > 0)
      q = q + " user:" + owner;
    if(searchScopes && searchScopes.length > 0)
      q = q + " in:" + searchScopes.join(',');

    return q;
  }


}]);
