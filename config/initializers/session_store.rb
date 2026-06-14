# frozen_string_literal: true

# Share session across bibliography.gr and www.bibliography.gr.
# Secure flag is applied by ActionDispatch::SSL when force_ssl + assume_ssl are enabled.
Rails.application.config.session_store :cookie_store,
  key: "_bibliography_session",
  same_site: :lax,
  httponly: true,
  domain: (Rails.env.production? || Rails.env.staging?) ? ".bibliography.gr" : nil
