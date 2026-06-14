# frozen_string_literal: true

# Share session across bibliography.gr and www.bibliography.gr (nginx may serve both).
# Without an explicit domain, host-only cookies break CSRF when www/apex differ.
Rails.application.config.session_store :cookie_store,
  key: "_bibliography_session",
  secure: Rails.env.production? || Rails.env.staging?,
  same_site: :lax,
  httponly: true,
  domain: (Rails.env.production? || Rails.env.staging?) ? ".bibliography.gr" : nil
