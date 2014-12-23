module Authentication
  module Strategies
    class ApiKey < Base

      def authenticate(token)
        @api_key_class.find_by_token(token)
      end

    end
  end
end
