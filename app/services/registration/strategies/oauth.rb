require 'generators/random_password'

module Registration
  module Strategies
    class Oauth < Base

      def register(oauth_params)
        provider = oauth_params[:provider]

        identity = Identity.new(provider: provider).from_oauth(oauth_params)
        @user = identity.to_user

        Identity.transaction do
          @user.save!
          identity.user = @user
          identity.save!
          identity.to_profile.save!
        end
        true
      rescue Exception => e
        Rails.logger.debug e.message
        false
      end
    end
  end
end
