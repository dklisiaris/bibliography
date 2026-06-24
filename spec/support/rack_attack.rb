# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :request) do
    next unless defined?(Rack::Attack)

    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.reset!
  end

  config.after(:each, type: :request) do
    next unless defined?(Rack::Attack)

    Rack::Attack.enabled = false
    Rack::Attack.reset!
  end
end
