Sidekiq.configure_server do |config|
  config.redis = { namespace: 'bibliography', url: ENV["REDIS_SERVER_URL"] }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'bibliography', url: ENV["REDIS_CLIENT_URL"] }
end

Sidekiq::Logging.logger.level = Logger::WARN
