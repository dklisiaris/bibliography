# frozen_string_literal: true

# Share session across bibliography.gr and www.bibliography.gr.
# Secure flag is applied by ActionDispatch::SSL when force_ssl + assume_ssl are enabled.
#
# Key was rotated to _bibliography_session_v2 (Rails 7.1 upgrade) so browsers stop sending
# duplicate legacy _bibliography_session cookies (host-only + domain) that broke CSRF login.
Rails.application.config.session_store :cookie_store,
  key: "_bibliography_session_v2",
  same_site: :lax,
  httponly: true,
  domain: (Rails.env.production? || Rails.env.staging?) ? ".bibliography.gr" : nil
