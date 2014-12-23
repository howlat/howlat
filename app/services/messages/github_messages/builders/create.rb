module Messages
  module GithubMessages
    module Builders
      class Create

        def call(message)
          parameters = message.parameters
          author = parameters['sender']['login']
          ref_type = parameters['ref_type']
          ref = parameters['ref']

          message.body = "#{author} created #{ref} #{ref_type}"
          message.tags.add "github:create:#{ref_type}"

          message
        end

      end
    end
  end
end
