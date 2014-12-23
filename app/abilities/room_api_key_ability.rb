class RoomApiKeyAbility
  include CanCan::Ability

  def initialize(api_key)
    room = api_key.room
    can :read, Room, id: room.id
    can :create, Message, room_id: room.id
    can :read, Badge
  end

end
