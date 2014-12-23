wizard.service("GithubService", ["GithubRepository", function(GithubRepository) {
  "use strict";

  var repositories, user_repositories, starred;

  this.loadRepositories = function(callback) {
    if(repositories) {
      callback(repositories);
    }
    else {
      var starred_repos_to_add = [];
      GithubRepository.query({}, function(data) {
        user_repositories = data;
        GithubRepository.starred({}, function(data) {
          starred = data;
          for(var i=0; i < starred.length; i++) {
            var starred_repo = starred[i];
            var found = false;
            for(var j=0; j < user_repositories.length; j++) {
              var user_repo = user_repositories[j];
              if(user_repo.id == starred_repo.id) {
                user_repo.starred = true;
                found = true;
                break;
              }
            };
            if(!found) {
              starred_repo.starred = true;
              starred_repos_to_add.push(starred_repo);
            }
          };
          repositories = user_repositories.concat(starred_repos_to_add)
          callback(repositories);
        });
      });
    };
  };

}]);
