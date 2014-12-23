module Messages
  module GithubMessages
    module Builders
      class Member

        def call(message)
          parameters = message.parameters
          member = parameters['member']['login']
          action = parameters['action']

          message.body = "#{member} #{action} to repository as collaborator"

          message
        end

      end
    end
  end
end
