# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rack::Attack", type: :request do
  describe "blocklist" do
    it "returns 403 for common scanner paths" do
      get "/wp-admin/login.php"

      expect(response).to have_http_status(403)
    end

    it "returns 403 for SQL injection probes in query strings" do
      get "/books/awarded", params: {
        prize_id: "429) AND CAST('~'||(SELECT 1)::text||'~' AS numeric)--"
      }

      expect(response).to have_http_status(403)
    end

    it "allows normal awarded book requests" do
      get "/books/awarded"

      expect(response).not_to have_http_status(403)
    end
  end

  describe "throttling" do
    it "returns 429 when the general rate limit is exceeded" do
      301.times { get "/books/awarded" }

      expect(response).to have_http_status(429)
    end
  end
end
