# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Content Security Policy", type: :request do
  it "sends a CSP header in report-only mode in test" do
    get pages_about_path

    expect(response.headers["Content-Security-Policy-Report-Only"]).to be_present
    expect(response.headers["Content-Security-Policy"]).to be_nil
  end

  it "does not include inline analytics scripts in the layout" do
    get pages_about_path

    expect(response.body).not_to include("GoogleAnalyticsObject")
    expect(response.body).not_to include("google-analytics.com/analytics.js")
  end

  it "includes a nonce on JSON-LD scripts" do
    get pages_about_path

    expect(response.body).to match(/application\/ld\+json[^>]*nonce="/)
  end
end
