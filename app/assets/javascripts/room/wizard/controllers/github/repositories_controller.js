wizard.controller("GithubRepositoriesCtrl",["$scope", "$timeout", "GithubRepository", "RoomService", function($scope, $timeout, GithubRepository, RoomService) {
  "use strict";

  $scope.room = RoomService.getRoom();

  $scope.all_repositories = [];
  // get all user repos
  $scope.repositories = GithubRepository.query({}, function() {
    // get all starred repos
    $scope.starred = GithubRepository.starred({}, function() {
      // apply starred attribute to these repositories
      angular.forEach($scope.starred, function(repo, index) {
        repo.starred = true;
      });
      // merge results
      $scope.all_repositories = $scope.repositories.concat($scope.starred)
    });
  });


}]);
