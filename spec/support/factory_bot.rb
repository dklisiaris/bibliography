# frozen_string_literal: true

# FactoryBot configuration
# This is already included in rails_helper, but keeping it here for clarity
# and in case we need to add custom factory bot configuration

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

