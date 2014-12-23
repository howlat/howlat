wizard.directive('serverErrors', function() {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      element.on('change', function() {
        scope.$apply(function() {
          scope.wizardForm[attrs.name].$setValidity('server', true);
        });
      });
    }
  };
})
;
