module Messages
  module GithubMessages
    module Builders
      class Public

        def call(message)

          message.body = "Repository has been open sourced"

          message
        end

      end
    end
  end
end
