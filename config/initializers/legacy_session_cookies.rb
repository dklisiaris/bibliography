# frozen_string_literal: true

# After the session key rotation, tell browsers to drop pre-Rails-7.1 session cookies.
# Duplicate _bibliography_session entries in the Cookie header (host-only + .domain)
# caused POST to load a different session than GET, breaking CSRF on login.
module LegacySessionCookies
  LEGACY_KEY = "_bibliography_session"

  def self.expire!(cookies, host:)
    return unless Rails.env.production? || Rails.env.staging?

    cookies.delete(LEGACY_KEY, path: "/")
    cookies.delete(LEGACY_KEY, path: "/", domain: ".bibliography.gr")

    # Host-only cookies set before domain: ".bibliography.gr" was introduced.
    cookies.delete(LEGACY_KEY, path: "/", domain: host) if host.present?
  end
end
