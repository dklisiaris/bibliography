# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:each, type: :request) do |example|
    next example.run unless defined?(Rack::Attack)

    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.reset!
    example.run
  ensure
    if defined?(Rack::Attack)
      Rack::Attack.enabled = false
      Rack::Attack.reset!
    end
  end
end
