wizard.factory('Room', function($resource) {
  return $resource('/organizations/:organization_id/rooms.json',
    { organization_id: '@organization_id' },
    {
      update: {
        method: 'PUT',
        isArray: false
      }
    });
});
