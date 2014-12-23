module Messages
  module GithubMessages
    module Builders
      class Issue

        def call(message)
          parameters = message.parameters
          author = parameters['issue']['user']['login']
          number = parameters['issue']['number']
          action = parameters['action']

          message.body = "#{author} #{action} issue ##{number}"
          message.tags.add "github:issue:#{number}"

          message
        end

      end
    end
  end
end
