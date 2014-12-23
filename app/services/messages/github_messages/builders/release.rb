module Messages
  module GithubMessages
    module Builders
      class Release

        def call(message)
          parameters = message.parameters
          author = parameters['release']['name']
          action = parameters['action']
          name = parameters['release']['author']['login']

          message.body = "#{author} #{action} release #{name}"

          message
        end
      end
    end
  end
end
