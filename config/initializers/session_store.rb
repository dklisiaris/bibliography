# frozen_string_literal: true

# Host-only session cookie (no domain:). Prefer one canonical host in nginx
# (www → bibliography.gr or the reverse) instead of sharing cookies across subdomains.
#
# Key _bibliography_session_v2: rotated during Rails 7.1 upgrade to drop duplicate
# legacy cookies that broke CSRF login.
Rails.application.config.session_store :cookie_store,
  key: "_bibliography_session_v2",
  same_site: :lax,
  httponly: true,
  secure: Rails.env.production? || Rails.env.staging?
