# Be sure to restart your server when you modify this file.
url = ENV["REDISCLOUD_URL"] || "redis://localhost:6379/"

Howlat::Application.config.cache_store = :redis_store, url
