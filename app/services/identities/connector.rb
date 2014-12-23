module Identities
  class Connector

    attr_accessor :identity

    def initialize
      @identity = nil
    end

    def call(user, identity_params)
      return false unless user
      provider = identity_params[:provider]
      @identity = user.identities.build(provider: provider).from_oauth(identity_params)
      @identity.save
    end

  end
end
