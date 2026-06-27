# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendationService::RedisStore do
  describe ".clear_user" do
    it "deletes known user keys and scans pairwise similarity keys" do
      user = build_stubbed(:user, id: 123)
      redis = instance_double(Redis)

      allow(described_class).to receive(:redis).and_return(redis)

      expect(redis).to receive(:del).with(
        "recommendations:user:123:recommendations:book",
        "recommendations:user:123:similar_users:book",
        "recommendations:user:123:similar_users"
      )
      expect(redis).to receive(:scan_each)
        .with(match: "recommendations:similarity:123:*:book")
        .and_yield("recommendations:similarity:123:456:book")
      expect(redis).to receive(:scan_each)
        .with(match: "recommendations:similarity:*:123:book")
        .and_yield("recommendations:similarity:42:123:book")
      expect(redis).to receive(:del).with("recommendations:similarity:123:456:book")
      expect(redis).to receive(:del).with("recommendations:similarity:42:123:book")

      described_class.clear_user(user, resource_types: ["Book"])
    end
  end
end
