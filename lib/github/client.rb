require 'octokit'

module Github
  class Client
    delegate :repositories, :user, :starred, :create_hook, :remove_hook, :hooks,
      :edit_hook, :repository, :search_repositories, :repository_events,
      to: :client

    attr_accessor :client
    private :client

    def initialize(options = {})
      @client = Octokit::Client.new(options)
    end

    def self.for_user(user)
      access_token = user.cached_github_identity.access_token
      new(access_token: access_token) if access_token
    end

    def self.for_app
      new(client_id: ENV['GITHUB_KEY'], client_secret: ENV['GITHUB_SECRET'])
    end

    def create_authorization(options = {})
      @client.create_authorization(options.merge({
        client_id: ENV['GITHUB_KEY'],
        client_secret: ENV['GITHUB_SECRET']
      }))
    end

  end
end
