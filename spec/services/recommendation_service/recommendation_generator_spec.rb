# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendationService::RecommendationGenerator do
  describe ".generate" do
    it "returns unrated neighbor-liked items ordered by recommendation score" do
      user = create(:user)
      first_neighbor = create(:user)
      second_neighbor = create(:user)
      strongest_book = create(:book)
      weaker_book = create(:book)
      already_rated_book = create(:book)

      allow(RecommendationService).to receive(:update_for)

      create(:rating, user: first_neighbor, rateable: strongest_book, rate: :like)
      create(:rating, user: second_neighbor, rateable: strongest_book, rate: :like)
      create(:rating, user: first_neighbor, rateable: weaker_book, rate: :like)
      create(:rating, user: first_neighbor, rateable: already_rated_book, rate: :like)
      create(:rating, user: user, rateable: already_rated_book, rate: :dislike)

      result = described_class.generate(
        user: user,
        resource_type: "Book",
        neighbors: [first_neighbor, second_neighbor],
        limit: 10
      )

      expect(result.map(&:id)).to eq([strongest_book.id, weaker_book.id])
    end
  end
end
