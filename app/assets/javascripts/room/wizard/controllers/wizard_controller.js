wizard.controller("WizardCtrl", ["$scope", "$timeout", "Room", "Repository", "GithubService", "BitbucketService", function($scope, $timeout, Room, Repository, GithubService, BitbucketService) {
  "use strict";

  $scope.errors = {};
  $scope.organization = {};
  $scope.progress = {
    class: 'btn-primary',
    text: 'Create Room',
    value: 0
  };
  $scope.room = {
    name: null,
    repository_attributes: {
      name: null,
      type: null
    }
  };
  $scope.repositories = [];
  $scope.repository = null;
  $scope.loadingRepos = false;
  $scope.repository_types = [
    {
      name: 'Github',
      value: 'github',
      active: 0
    },
    {
      name: 'Bitbucket',
      value: 'bitbucket',
      active: 0
    }
  ];

  $scope.initialize = function (data) {
    $scope.organization = data.organization;
    angular.forEach($scope.repository_types, function(type){
      if(data.connected_accounts.indexOf(type.value) >= 0)
        type.active = 1;
    });
    $scope.user = data.user;
    $scope.room.organization_id = $scope.organization.id
  }


  $scope.$watch('room.repository_attributes.type', function(new_type) {
    if(new_type)
      $scope.loadingRepos = true;
    if(new_type === 'github')
      GithubService.loadRepositories(function(data) {
        $scope.repositories = data;
        $scope.loadingRepos = false;
      });
    else if(new_type === 'bitbucket')
      $scope.repositories = BitbucketService.loadRepositories(function(data) {
        $scope.repositories = data;
        $scope.loadingRepos = false;
      });
  })

  $scope.$watch('progress.value' , function(new_value){
    if(new_value === 100)
      $scope.goToRoom();
  })

  $scope.submit = function() {
    $scope.errors = {};
    $scope.progress.text = 'Submitting...';
    var success = function(room) {
      $scope.progress.text = 'Connecting repository...';
      $scope.repository = room.repository;
      $scope.persistedRoom = room;
      $scope.progress.value = 50;
      $scope.connectRepository(room.repository);
    }
    var failure = function(response) {
      $scope.progress.text = 'Create Room'
      $scope.handleErrors(response.data.errors, 'room');
    }
    var params = {
      organization_id: $scope.organization.id,
      room: $scope.room
    }
    Room.save(params, success, failure);
  };

  $scope.connectRepository = function(repository){
    var success = function(response) {
      $scope.progress.value = 100;
    };
    var failure = function(response) {
      $scope.handleErrors(response.data.errors, 'room');
      $scope.progress.class= 'hide'
      $timeout(function(){
        $scope.progress.value = 100;
      }, 2000);
    };
    var params = {
      organization_id: $scope.organization.id,
      room_id: repository.room_id
    };
    Repository.connect(params, success, failure);
  }

  $scope.handleErrors = function(errors, namespace){
    angular.forEach(errors, function(field_errors, field){
      var formField, fieldname;
      // tell the form that field is invalid
      fieldname = namespace + '.' + field;
      formField = $scope.wizardForm[fieldname];
      if(formField)
        formField.$setValidity('server', false);
      // keep the error messages from the server
      $scope.errors[fieldname] = field_errors.join(', ');
    });
  }

  $scope.goToRoom = function(){
    window.location = ['/chat', $scope.organization.slug, $scope.persistedRoom.slug].join("/")
  };

}]);
