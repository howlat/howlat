class UserAbility
  include CanCan::Ability

  def initialize(user)

    # Aliases
    alias_action :create, :read, :update, :destroy, to: :crud

    # User to check
    user ||= User.new

    ######################
    # Accounts & Identity #
    ######################

    can :manage, Identity, user_id: user.id
    cannot :destroy, Identities::Github

    can [:update, :destroy], User, id: user.id
    can :read, User

    can [:update], Profile, account: user
    can :read, Profile

    can [:read, :edit, :update], Preferences, user: user

    ########
    # Room #
    ########

    can :index, Room, access: 'public'
    can :index, Room, access: 'private', memberships: { user_id: user.id }

    can [:show, :hide, :leave], Room do |room|
      if room.access_policy == 'github'
        authorize_github_repo_access(user, room.repository)
      else
        room.public? or room.private? && room.memberships.where(user_id: user.id).exists?
      end
    end

    can :update, Room do |room|
      if room.access_policy == 'github'
        authorize_github_repo_admin_access(user, room.repository)
      else
        room.public? or room.private? && room.memberships.where(user_id: user.id).exists?
      end
    end

    can :create, Room
    can :read, Badge

    ##############
    # Invitation #
    ##############

    can :manage, Invitation

    ###########
    # Message #
    ###########

    can [:read, :search], Message
    can :create, Message do |message|
      message.author.eql?(user) &&
      user.room_memberships.where(room_id: message.room_id).exists?
    end
    can [:update, :destroy], Message, author_id: user.id
    can [:add_tag, :remove_tag], Message do |message|
      user.room_memberships.where(room_id: message.room_id).exists?
    end

    can [:read, :create], Tag

    ##############
    # GITHUB API #
    ##############

    can :read, :github do
      user.cached_github_identity.present?
    end

    ##############
    # Repository #
    ##############

    if user.cached_github_identity.present?
      can [:read, :create], Repositories::GithubRepository do |repo|
        authorize_github_repo_access(user, repo)
      end
      can [:update, :connect, :disconnect], Repositories::GithubRepository do |repo|
        authorize_github_repo_admin_access(user, repo)
      end
    end

  end

  private

  def github_client_for(user)
    @clients ||= {}
    @clients[user.id] ||= ::Github::Client.for_user(user)
  end

  def authorize_github_repo_access(user, repo)
    begin
      github_client_for(user).repository(repo.name)
    rescue NoMethodError, Octokit::NotFound
      false
    end
  end

  def authorize_github_repo_admin_access(user, repo)
    begin
      github_client_for(user).hooks(repo.name)
    rescue NoMethodError, Octokit::NotFound
      false
    end
  end

end
