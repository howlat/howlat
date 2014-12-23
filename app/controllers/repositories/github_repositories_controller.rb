module Repositories
  class GithubRepositoriesController < RepositoriesController

    def show
      authorize! :edit, @repository
      render :edit
    end

    def edit
    end

    private

    def connection_params
      params.require(:repositories_github_repository).permit(events: [])
    end

  end
end
