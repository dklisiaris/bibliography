# frozen_string_literal: true

# Sidekiq 7+ no longer supports the redis-namespace option in config.redis.
# Logger must be set on config inside configure_server (not Sidekiq.logger=).
Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_SERVER_URL"] }

  if Rails.env.production? || Rails.env.staging?
    log_file = Rails.root.join('log', 'sidekiq.log')
    FileUtils.mkdir_p(File.dirname(log_file))
    config.logger = Logger.new(log_file)
  end

  config.logger.level = Logger::WARN
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_CLIENT_URL"] }
end
