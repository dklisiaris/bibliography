Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_SERVER_URL"] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_CLIENT_URL"] }
end