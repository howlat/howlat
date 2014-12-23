wizard.factory('Repository', function($resource) {
  return $resource('/organizations/:organization_id/rooms/:room_id/repository/:action.json',
    { room_id: '@room_id', organization_id: '@organization_id' },
    {
      connect: {
        params: {
          action: 'connect'
        },
        method: 'POST',
        isArray: false
      }
    });
});
