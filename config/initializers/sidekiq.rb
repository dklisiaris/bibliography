Sidekiq.configure_server do |config|
  config.redis = { namespace: 'bibliography', url: ENV["REDIS_SERVER_URL"] }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'bibliography', url: ENV["REDIS_CLIENT_URL"] }
end

# Configure logging for Sidekiq 6+
# Sidekiq 6 logs to STDOUT by default, redirect to log file in production/staging
if Rails.env.production? || Rails.env.staging?
  log_file = Rails.root.join('log', 'sidekiq.log')
  # Ensure log directory exists
  FileUtils.mkdir_p(File.dirname(log_file))
  Sidekiq.logger = Logger.new(log_file)
  Sidekiq.logger.level = Logger::WARN
else
  # In development, log to STDOUT (default behavior)
  Sidekiq.logger.level = Logger::WARN
end
