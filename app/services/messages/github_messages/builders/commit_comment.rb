module Messages
  module GithubMessages
    module Builders
      class CommitComment

        def call(message)
          parameters = message.parameters
          author = parameters['comment']['user']['login']
          commit_id = parameters['comment']['commit_id'].slice(0..6)

          message.body = "#{author} commented commit #{commit_id}"
          message.tags.add "github:commit:#{commit_id}:comment"

          message
        end

      end
    end
  end
end
