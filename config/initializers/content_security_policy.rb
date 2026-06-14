# frozen_string_literal: true

# Content Security Policy — report-only (Phase 0).
#
# Sends Content-Security-Policy-Report-Only (not enforced). The browser logs
# violations in DevTools → Console but does not block scripts/styles/images.
#
# Expected violations on this legacy stack (fix before enforcing):
#   - Inline <script> blocks (Google Analytics, flash toasts, JSON-LD)
#   - Inline event handlers (onclick="javascript:like(...)" etc.)
#
# To enforce later: set content_security_policy_report_only = false after
# moving inline JS to assets/nonces and upgrading to Rails 7+.
#
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only

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

Rails.application.config.content_security_policy_report_only = true
