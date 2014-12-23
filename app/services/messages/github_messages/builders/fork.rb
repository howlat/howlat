module Messages
  module GithubMessages
    module Builders
      class Fork

        def call(message)
          parameters = message.parameters
          author = parameters['forkee']['owner']['login']
          fork_name = parameters['forkee']['full_name']

          message.body = "#{author} forked this repo into #{fork_name}"

          message
        end

      end
    end
  end
end
