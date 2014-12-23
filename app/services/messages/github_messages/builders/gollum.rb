module Messages
  module GithubMessages
    module Builders
      class Gollum

        def call(message)

          message.body = "Repository wiki has been updated"

          message
        end

      end
    end
  end
end
