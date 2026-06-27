require "rails_helper"

RSpec.describe Rating, type: :model do
  describe "recommendation refresh callback" do
    it "enqueues a scoped recommendation update for the rated resource type" do
      user = create(:user)
      book = create(:book)

      expect(RecommendationService).to receive(:update_for).with(user, resource_type: "Book")

      create(:rating, user: user, rateable: book)
    end
  end
end
