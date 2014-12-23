//= require_self

//= require_tree ./controllers
//= require_tree ./resources

var repoSearch = angular.module("repoSearch",  ['ngResource']);

repoSearch.config(["$httpProvider", function(provider) {
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
}]);
