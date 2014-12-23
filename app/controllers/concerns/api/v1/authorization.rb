module Api
  module V1
    module Authorization
      extend ActiveSupport::Concern

      included do
        check_authorization

        rescue_from CanCan::AccessDenied do |exception|
          render :text => exception.message, :status => 403
        end

        def current_ability
          @current_ability ||= Ability.for(api_key)
        end

      end
    end
  end
end
