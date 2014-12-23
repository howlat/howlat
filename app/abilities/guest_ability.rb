class GuestAbility
  include CanCan::Ability

    def initialize(guest)
      can :create, User
      can :read, Badge
    end

end
