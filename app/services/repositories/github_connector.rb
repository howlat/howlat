require 'github/client'

module Repositories
  class GithubConnector < Connector
    Client = ::Github::Client

    delegate :url_helpers, to: 'Rails.application.routes'
    alias_method :url, :url_helpers

    attr_accessor :client
    private :client

    def initialize(user)
      @user = user
      @identity = user ? user.identities.github.first : nil
      @client = Client.new(access_token: @identity.try(:access_token))
    end

    def connect(repository)
      result = transaction do
        hook = update_or_create_hook!(repository)
        repository.hook_id = hook.id
        repository.save!
      end

      repository.errors.add(:base, 'Could not connect repository') unless result

      result
    end

    def disconnect(repository)
      result = transaction do
        remove_hook!(repository)
        repository.update(hook_id: nil, events: nil)
      end

      repository.errors.add(:base, 'Could not disconnect repository') unless result

      result
    end

    private

    def transaction(&block)
      Repository.transaction do
        yield
      end
    rescue Exception => e
      Rails.logger.debug e.message
      false
    end

    def webhook_url(repository)
      params = {
        host: ENV['DOMAIN_NAME'],
        token: repository.room.api_key.token
      }
      url.api_v1_github_callback_url(params)
    end

    def update_or_create_hook!(repository)
      if repository.hook_id?
        update_hook!(repository)
      else
        create_hook!(repository)
      end
    end

    def remove_hook!(repository)
      client.remove_hook repository.name, repository.hook_id
    end

    def create_hook!(repository)
      config, options = hook_config(repository), hook_options(repository)
      client.create_hook(repository.name, 'web', config, options)
    end

    def update_hook!(repository)
      config, options = hook_config(repository), hook_options(repository)
      client.edit_hook(repository.name, repository.hook_id, 'web', config, options)
    end

    def hook_config(repository)
      { url: webhook_url(repository), content_type: :json }
    end

    def hook_options(repository)
      { events: repository.events }
    end

  end
end
