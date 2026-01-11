# frozen_string_literal: true

# Time helpers for freezing time in tests
# Useful for testing time-dependent functionality
# ActiveSupport::Testing::TimeHelpers provides: travel_to, travel_back, freeze_time

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
end

