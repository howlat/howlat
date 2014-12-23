module Messages
  module GithubMessages
    module Builders
      class PullRequestReviewComment

        def call(message)
          parameters = message.parameters
          author = parameters['comment']['user']['login']
          commit_id = parameters['comment']['commit_id'].slice(0..6)
          file = parameters['comment']['path']

          message.body = "#{author} put a comment on #{file}(#{commit_id})"

          message
        end

      end
    end
  end
end
