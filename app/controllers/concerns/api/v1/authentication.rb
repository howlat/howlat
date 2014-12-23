module Api
  module V1
    module Authentication
      extend ActiveSupport::Concern

      included do
        prepend_before_filter :authenticate!
        attr_reader :api_key

        def authenticate!
          # from session
          if logged_in?
            @api_key = current_user.api_key
            return true
          end
          # from token in request
          return true if authenticate_from_request_token
          # from token in header
          authenticate_or_request_with_http_token do |token, options|
            authenticate_from_token(token)
          end
        end

        def authenticate_from_request_token
          return false unless params[:token].present? # skip
          authenticate_from_token(params[:token])
        end

        def authenticate_from_token(token)
          @api_key = ::Authentication::Service.new(:api_key).call(token)
        end

      end
    end
  end
end
