# frozen_string_literal: true

# Database Cleaner configuration for test suite
# Uses database_cleaner-active_record for better control over database state
# Note: We're using transactional fixtures in rails_helper, so database_cleaner
# will work alongside it. For JS tests, we'll use truncation.

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # For most tests, use transaction (faster)
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # For feature tests that require JavaScript, use truncation
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

