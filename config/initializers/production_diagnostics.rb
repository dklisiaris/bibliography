# frozen_string_literal: true

# Temporary production debugging — enable only while investigating an issue.
#
#   ENABLE_BETTER_ERRORS=1 passenger-config restart-app /var/www/bibliography/current
#
# Disable when done:
#   unset ENABLE_BETTER_ERRORS && passenger-config restart-app ...
#
return unless Rails.env.production?
return unless ENV["ENABLE_BETTER_ERRORS"] == "1"

require "better_errors"

Rails.application.config.middleware.insert_after ActionDispatch::DebugExceptions, BetterErrors::Middleware
Rails.application.config.consider_all_requests_local = true

Rails.logger.warn(
  "[production_diagnostics] Better Errors enabled. " \
  "Unset ENABLE_BETTER_ERRORS and restart Passenger when finished."
)
