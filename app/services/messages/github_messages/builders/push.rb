module Messages
  module GithubMessages
    module Builders
      class Push

        def call(message)
          parameters = message.parameters
          commits = parameters['commits']
          pusher = parameters['pusher']['name']
          ref = parameters['ref']
          if(ref =~ /refs\/tags/)
            type = "tag"
            name = ref.sub('refs/tags/', '')
          else
            type = "branch"
            name = ref.sub('refs/heads/', '')
          end

          message.body = "#{pusher} pushed to #{name} #{type}"
          message.body << ": " unless commits.empty?
          message.body << commits.map do |commit|
            id = commit['id'].slice(0..6)
            message = commit['message'].truncate(50)
            "#{message}(#{id})"
          end.join(',')

          message
        end
      end
    end
  end
end
