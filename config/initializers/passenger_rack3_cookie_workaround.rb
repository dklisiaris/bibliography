# frozen_string_literal: true

require Rails.root.join("lib/middleware/passenger_rack3_cookie_workaround")

# Must run outermost so all downstream middleware (including ActionDispatch::SSL / cookies)
# has its array headers flattened before Passenger serializes the response.
Rails.application.config.middleware.insert_before(0, PassengerRack3CookieWorkaround)
