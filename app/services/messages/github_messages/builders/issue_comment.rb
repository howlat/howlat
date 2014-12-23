module Messages
  module GithubMessages
    module Builders
      class IssueComment

        def call(message)
          parameters = message.parameters
          author = parameters['comment']['user']['login']
          number = parameters['issue']['number']
          action = parameters['action']

          message.body = "#{author} #{action} comment on issue ##{number}"
          message.tags.add "github:issue:#{number}:comment"

          message
        end

      end
    end
  end
end
