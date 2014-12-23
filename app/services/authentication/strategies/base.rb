module Authentication
  module Strategies
    class Base

      def initialize(user_class, api_key_class)
        @user_class = user_class
        @api_key_class = api_key_class
      end

      def authenticate(credentials)
        raise NotImplementedError
      end

    end

  end
end
