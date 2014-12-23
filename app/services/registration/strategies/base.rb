module Registration
  module Strategies
    class Base

      attr_reader :user

      def initialize(user_class)
        @user_class = user_class
        @user = nil
      end

      def register(registration_params)
        raise NotImplementedError
      end

    end

  end
end
