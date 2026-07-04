# frozen_string_literal: true

# Content Security Policy
#
# Enforced in production/staging; report-only in development/test so local
# debugging stays frictionless.
#
# Inline JSON-LD uses per-request nonces (see content_security_policy_nonce_*).
# Google Analytics loads from hotwire.js (analytics.js) — no inline scripts.
#
# https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP

Rails.application.config.content_security_policy do |policy|
  policy.default_src     :self, :https
  policy.base_uri        :self
  policy.font_src        :self, :https, :data
  policy.img_src         :self, :https, :data, :blob
  policy.object_src      :none
  policy.script_src      :self, :https
  policy.style_src       :self, :https, :unsafe_inline
  policy.connect_src     :self, :https
  policy.frame_src       :self, :https
  policy.form_action     :self, :https
  policy.frame_ancestors :self
end

Rails.application.config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
Rails.application.config.content_security_policy_nonce_directives = %w[script-src]

Rails.application.config.content_security_policy_report_only = Rails.env.local?
