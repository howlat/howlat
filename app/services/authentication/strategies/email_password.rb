module Authentication
  module Strategies
    class EmailPassword < Base

      def authenticate(credentials)
        return nil unless validate(credentials)
        email = credentials[:email]
        password = credentials[:password]
        remember_me = credentials[:remember_me]
        @user_class.authenticate(email, password, remember_me)
      end

      private

      def validate(credentials)
        credentials.kind_of?(Hash) &&
        credentials[:email] &&
        credentials[:password]
      end

    end
  end
end
