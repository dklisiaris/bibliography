# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdateRecommendationsJob, type: :job do
  describe "#perform" do
    it "refreshes only the requested resource types" do
      user = build_stubbed(:user)
      recommendations = [instance_double(Book)]
      similar_users = [instance_double(User)]

      allow(User).to receive(:find_by).with(id: user.id).and_return(user)

      expect(RecommendationService).to receive(:recommendations_for).with(
        user,
        resource_type: "Book",
        limit: 100,
        force_recalculate: true
      ).and_return(recommendations)
      expect(RecommendationService).to receive(:similar_users).with(
        user,
        limit: 20,
        resource_type: "Book",
        force_recalculate: true
      ).and_return(similar_users)

      described_class.perform_now(user.id, resource_types: ["Book"])
    end

    it "does nothing when the user no longer exists" do
      allow(User).to receive(:find_by).with(id: 999).and_return(nil)

      expect(RecommendationService).not_to receive(:recommendations_for)

      described_class.perform_now(999, resource_types: ["Book"])
    end
  end
end
