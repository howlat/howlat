module Registration
  module Strategies
    class Form < Base

      def register(registration_params)
        @user = @user_class.new(registration_params)
        @user.build_profile(name: @user.name) unless @user.profile
        @user.profile.email = @user.email
        @user.password_set = true
        @user.save
      end

    end
  end
end
