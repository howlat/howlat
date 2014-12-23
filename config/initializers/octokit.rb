require 'octokit'
require 'faraday'
require 'faraday-http-cache'
require 'oj'

Octokit.middleware = Faraday::Builder.new do |builder|
  #builder.response :logger if Rails.env.development?
  builder.use Faraday::HttpCache, store: Rails.cache, shared_cache: false,
    serializer: Oj#, logger: Rails.env.development? ? Rails.logger : nil
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
