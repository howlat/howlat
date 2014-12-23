wizard.service("BitbucketService", ["BitbucketRepository", function(BitbucketRepository) {
  "use strict";

  var repositories = [];

  this.loadRepositories = function() {
    return repositories;
  };
}]);
