module Authentication
  module Strategies
    class Oauth < Base

      def authenticate(credentials)
        return nil unless validate(credentials)
        provider = credentials[:provider]
        uid = credentials[:uid]
        @user_class.
          joins(:identities).
          where(identities: { provider: provider, uid: uid }).
          first
      end

      def validate(credentials)
        credentials.kind_of?(Hash) &&
        credentials[:provider] &&
        credentials[:uid]
      end

    end
  end
end
