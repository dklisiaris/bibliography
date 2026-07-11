# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rack::Attack", type: :request do
  # Use a fixed client IP so throttling is deterministic across environments.
  let(:client_ip) { "198.51.100.42" }
  let(:client_env) { { "REMOTE_ADDR" => client_ip } }

  describe "blocklist" do
    it "returns 403 for common scanner paths" do
      get "/wp-admin/login.php", env: client_env

      expect(response).to have_http_status(403)
    end

    it "returns 403 for SQL injection probes in query strings" do
      get "/books/awarded", params: {
        prize_id: "429) AND CAST('~'||(SELECT 1)::text||'~' AS numeric)--"
      }, env: client_env

      expect(response).to have_http_status(403)
    end

    it "allows normal awarded book requests" do
      get "/books/awarded", env: client_env

      expect(response).not_to have_http_status(403)
    end
  end

  describe "throttling" do
    it "returns 429 when the general rate limit is exceeded" do
      period = 5.minutes.to_i
      throttle_key = "requests/ip:#{client_ip}"

      # Production rule: 300 requests / 5 minutes. Prime the cache to the limit
      # instead of issuing 301 full HTTP requests (slow and flaky in CI).
      300.times { Rack::Attack.cache.count(throttle_key, period) }

      get "/books/awarded", env: client_env

      expect(response).to have_http_status(429)
      expect(response.body).to include("Too many requests")
    end
  end
end
