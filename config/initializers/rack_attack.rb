# frozen_string_literal: true

require "cgi"

# Rate limits and blocklists for scanners / abusive traffic.
# Off in test by default (enabled per-example in spec/support/rack_attack.rb).
# Enable locally with RACK_ATTACK_ENABLED=1.

Rack::Attack.enabled = !Rails.env.test? && (
  Rails.env.production? || Rails.env.staging? || ENV["RACK_ATTACK_ENABLED"] == "1"
)

Rack::Attack.cache.store =
  if Rails.env.test? || (Rails.env.development? && ENV["REDIS_SERVER_URL"].blank?)
    ActiveSupport::Cache::MemoryStore.new
  else
    ActiveSupport::Cache::RedisCacheStore.new(
      url: ENV["REDIS_SERVER_URL"],
      namespace: "bibliography:rack-attack",
      error_handler: ->(method:, returning:, exception:) {
        Rails.logger.warn("[Rack::Attack] Redis cache #{method} failed: #{exception.class}: #{exception.message}")
        returning
      }
    )
  end

module RackAttackRules
  PROBE_PATH = %r{
    \A/(
      wp-admin | wp-login\.php | wordpress | xmlrpc\.php |
      phpmyadmin | pma | admin\.php | \.env | \.git | \.vscode |
      cgi-bin | shell | vendor/phpunit | _profiler | actuator
    )
  }ix

  PROBE_EXTENSION = /\.(php|asp|aspx|jsp|cgi)\z/i

  SQLI_PROBE = %r{
    (/\*|\*/|;\s*--|\bunion\b.+\bselect\b|\bcase\b.+\bwhen\b.+\bthen\b|
     cast\s*\(|::text\s*::\s*numeric|sleep\s*\(|benchmark\s*\(|0x[0-9a-f]{4,})
  }ix
end

Rack::Attack.safelist("localhost") do |req|
  !Rails.env.test? && (req.ip == "127.0.0.1" || req.ip == "::1")
end

Rack::Attack.safelist("OAuth callbacks") do |req|
  req.path.start_with?("/users/auth/")
end

Rack::Attack.blocklist("probe paths") do |req|
  req.path.match?(RackAttackRules::PROBE_PATH) ||
    req.path.match?(RackAttackRules::PROBE_EXTENSION)
end

Rack::Attack.blocklist("sqli probes") do |req|
  query = req.query_string
  next false if query.blank?

  decoded = CGI.unescape(query)
  [query, decoded].any? { |q| q.match?(RackAttackRules::SQLI_PROBE) }
end

Rack::Attack.throttle("requests/ip", limit: 300, period: 5.minutes) do |req|
  req.ip unless req.path.start_with?("/assets")
end

Rack::Attack.throttle("search/ip", limit: 60, period: 1.minute) do |req|
  req.ip if req.path.start_with?("/search", "/autocomplete")
end

Rack::Attack.throttle("api/ip", limit: 120, period: 1.minute) do |req|
  req.ip if req.path.start_with?("/api/")
end

Rack::Attack.throttled_responder = lambda do |request|
  match_data = request.env["rack.attack.match_data"]
  retry_after = match_data[:period] if match_data
  headers = retry_after ? { "Retry-After" => retry_after.to_s } : {}

  [429, headers, ["Too many requests\n"]]
end

unless Rails.env.test?
  ActiveSupport::Notifications.subscribe(/rack_attack/) do |_name, _start, _finish, _id, payload|
    req = payload[:request]
    match = req.env["rack.attack.match_type"]
    Rails.logger.warn("[Rack::Attack] #{match} blocked #{req.ip} #{req.request_method} #{req.fullpath}")
  end
end
