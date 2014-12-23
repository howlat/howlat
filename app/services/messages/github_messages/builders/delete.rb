module Messages
  module GithubMessages
    module Builders
      class Delete

        def call(message)
          parameters = message.parameters
          author = parameters['sender']['login']
          ref_type = parameters['ref_type']
          ref = parameters['ref']

          message.body = "#{author} deleted #{ref} #{ref_type}"
          message.tags.add "github:delete:#{ref_type}"

          message
        end

      end
    end
  end
end
