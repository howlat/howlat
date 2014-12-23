module Api
  module V1
    module Github
      class RepositoriesController < Api::V1::Github::BaseController

        def search
          @repositories = github.search_repositories(query,
            sort: sort, order: order, page: page, per_page: per_page)
          respond_with @repositories
        rescue Octokit::UnprocessableEntity
          respond_with items: [], total_count: 0
        end

        def index
          @repositories = github.repositories
          respond_with @repositories
        end

        def starred
          @repositories = github.starred
          respond_with @repositories
        end

        def private
          @repositories = github.repositories(nil, type: 'private')
          respond_with @repositories
        end

        def public
          @repositories = github.repositories(nil, type: 'public')
          respond_with @repositories
        end

        def events
          repo = params[:name]
          limit = params[:limit].to_i > 0 ? params[:limit].to_i : 5
          @repository_events = github.repository_events(repo)

          respond_with @repository_events.slice(0..limit - 1)
        end

        private

        def query
          params.require(:query)
        end

        def page
          params[:page] || 1
        end

        def per_page
          params[:per_page] || 10
        end

        def sort
          params[:sort] || :stars
        end

        def order
          params[:order] || :desc
        end

      end
    end
  end
end
