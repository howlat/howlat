//= require angular
//= require angular-resource
//= require angular-route

//= require_self

//= require_tree ./controllers
//= require_tree ./directives
//= require_tree ./resources
//= require_tree ./services

var wizard = angular.module("wizard",  ['ngResource', 'ngRoute']);

wizard.config(["$httpProvider", function(provider) {
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
}]);
