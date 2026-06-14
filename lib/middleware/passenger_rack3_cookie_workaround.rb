# frozen_string_literal: true

# Rack 3 returns response header values as Arrays (e.g. multiple Set-Cookie lines).
# Passenger releases before 6.0.19 stringify those arrays incorrectly, producing
# cookie names like ["_bibliography_session instead of _bibliography_session.
# That breaks session round-trip and causes InvalidAuthenticityToken on login.
#
# https://github.com/phusion/passenger/issues/2503
# Fix long-term: upgrade Passenger to 6.0.19+ (full Rack 3 support).
class PassengerRack3CookieWorkaround
  MIN_PASSENGER_VERSION = Gem::Version.new("6.0.19")

  def initialize(app)
    @app = app
    @logged = false
  end

  def call(env)
    status, headers, body = @app.call(env)

    if apply_workaround?(env)
      log_once(env)
      headers.each do |key, value|
        headers[key] = value.join("\n") if value.is_a?(Array)
      end
    end

    [status, headers, body]
  end

  private

  def apply_workaround?(env)
    return false unless Rails.env.production? || Rails.env.staging?

    software = env["SERVER_SOFTWARE"].to_s
    return false unless software.include?("Phusion")

    version = passenger_version(software)
    version.nil? || version < MIN_PASSENGER_VERSION
  end

  def passenger_version(software)
    match = software.match(/(\d+\.\d+\.\d+)/)
    return nil unless match

    Gem::Version.new(match[1])
  rescue ArgumentError
    nil
  end

  def log_once(env)
    return if @logged

    @logged = true
    software = env["SERVER_SOFTWARE"].to_s
    version = passenger_version(software)
    label = version ? "Passenger #{version}" : software
    Rails.logger.warn(
      "[PassengerRack3CookieWorkaround] enabled for #{label} — " \
      "flattening Rack 3 array response headers. Upgrade Passenger to #{MIN_PASSENGER_VERSION}+ when possible."
    )
  end
end
