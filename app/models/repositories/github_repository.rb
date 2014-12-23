module Repositories
  class GithubRepository < Repository
    # ALL EVENTS
    # "push", "issues", "issue_comment", "commit_comment", "create", "delete",
    # "pull_request", "pull_request_review_comment", "gollum", "watch",
    # "release", "fork", "member", "public", "team_add"

    # events we support
    EVENTS = %w(push issues issue_comment create delete pull_request
      commit_comment fork gollum member public pull_request_review_comment
      release)

    validate :validate_events

    before_validation { self.events.reject!(&:blank?) if self.events }

    private

    def validate_events
      if hook_id? && (invalid_events = (events - EVENTS))
        invalid_events.each do |event|
          errors.add(:events, event + " is not a valid event")
        end
      end
    end

  end
end
