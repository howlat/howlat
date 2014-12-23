Rails.application.config.middleware.insert_after Middlewares::OauthContextManager, OmniAuth::Builder do
  provider :bitbucket, ENV['BITBUCKET_KEY'], ENV['BITBUCKET_SECRET']
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user, repo"
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
  provider :twitter, ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"]
end
