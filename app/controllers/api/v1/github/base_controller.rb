require 'github/client'

module Api
  module V1
    module Github
      class BaseController < ::Api::V1::BaseController
        skip_authorization_check

        rescue_from(Octokit::NotFound) do |exception|
          head :not_found
        end

        protected

        def github
          @github ||= ::Github::Client.new(access_token: github_access_token)
        end

        private

        def github_access_token
          authorize! :read, :github
          @identity ||= api_key.try(:user).try(:cached_github_identity)
          @identity.try(:access_token)
        end
      end
    end
  end
end
