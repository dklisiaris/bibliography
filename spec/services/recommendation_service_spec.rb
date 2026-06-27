# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendationService do
  describe ".update_for" do
    it "clears scoped caches before enqueueing a scoped refresh job" do
      user = build_stubbed(:user)

      expect(described_class::CacheManager).to receive(:clear_user).with(user, resource_types: ["Book"])
      expect(described_class::RedisStore).to receive(:clear_user).with(user, resource_types: ["Book"])
      expect(UpdateRecommendationsJob).to receive(:perform_later).with(user.id, resource_types: ["Book"])

      described_class.update_for(user, resource_type: "Book")
    end

    it "falls back to all known resource types when no scope is provided" do
      user = build_stubbed(:user)

      allow(described_class::CacheManager).to receive(:clear_user)
      allow(described_class::RedisStore).to receive(:clear_user)

      expect(UpdateRecommendationsJob).to receive(:perform_later).with(
        user.id,
        resource_types: described_class::RESOURCE_TYPES
      )

      described_class.update_for(user)
    end
  end

  describe "#recommendations" do
    it "skips Rails cache and Redis reads when force recalculation is requested" do
      user = build_stubbed(:user)
      service = described_class.new(user, "Book", 10, true)

      allow(described_class::NeighborFinder).to receive(:find).and_return(User.none)
      allow(described_class::RecommendationGenerator).to receive(:generate).and_return(Book.none)
      allow(described_class::RedisStore).to receive(:store_recommendations)
      allow(described_class::CacheManager).to receive(:cache_recommendations)

      expect(described_class::CacheManager).not_to receive(:get_recommendations)
      expect(described_class::RedisStore).not_to receive(:get_recommendations)

      service.recommendations
    end
  end
end
