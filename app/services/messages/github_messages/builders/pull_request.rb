module Messages
  module GithubMessages
    module Builders
      class PullRequest

        def call(message)
          parameters = message.parameters
          user = parameters['pull_request']['user']['login']
          action = parameters['action']
          number = parameters['number']

          message.body = "#{user} #{action} pull request ##{number}"
          message.tags.add "github:pull_request:#{number}"

          message
        end
      end
    end
  end
end
