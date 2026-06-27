# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendationService::NeighborFinder do
  before { allow(RecommendationService).to receive(:update_for) }

  def like_books(user, books)
    books.each { |book| create(:rating, user: user, rateable: book, rate: :like) }
  end

  describe ".find" do
    it "returns cached neighbors from Redis without recalculating" do
      user = create(:user)
      cached_neighbor = create(:user)

      allow(RecommendationService::RedisStore).to receive(:get_similar_users)
        .with(user, 20, resource_type: "Book")
        .and_return(User.where(id: cached_neighbor.id))

      expect(RecommendationService::RedisStore).not_to receive(:store_similar_users)

      result = described_class.find(user, limit: 20, resource_type: "Book")

      expect(result.map(&:id)).to eq([cached_neighbor.id])
    end

    it "returns users ordered by jaccard similarity when cache is cold" do
      user = create(:user)
      closest_neighbor = create(:user)
      weaker_neighbor = create(:user)

      shared_books = create_list(:book, 6)
      closest_only_books = create_list(:book, 2)
      weaker_only_books = create_list(:book, 3)

      like_books(user, shared_books)
      like_books(closest_neighbor, shared_books + closest_only_books)
      like_books(weaker_neighbor, shared_books.first(3) + weaker_only_books)

      allow(RecommendationService::RedisStore).to receive(:get_similar_users).and_return(User.none)
      allow(RecommendationService::RedisStore).to receive(:get_similarity).and_return(nil)
      allow(RecommendationService::RedisStore).to receive(:store_similarity)
      allow(RecommendationService::RedisStore).to receive(:store_similar_users)

      result = described_class.find(user, limit: 20, resource_type: "Book")

      expect(result.map(&:id)).to eq([closest_neighbor.id, weaker_neighbor.id])
    end

    it "respects the requested limit" do
      user = create(:user)
      first_neighbor = create(:user)
      second_neighbor = create(:user)
      shared_books = create_list(:book, 6)

      like_books(user, shared_books)
      like_books(first_neighbor, shared_books)
      like_books(second_neighbor, shared_books.first(3) + create_list(:book, 3))

      allow(RecommendationService::RedisStore).to receive(:get_similar_users).and_return(User.none)
      allow(RecommendationService::RedisStore).to receive(:get_similarity).and_return(nil)
      allow(RecommendationService::RedisStore).to receive(:store_similarity)
      allow(RecommendationService::RedisStore).to receive(:store_similar_users)

      result = described_class.find(user, limit: 1, resource_type: "Book")

      expect(result.map(&:id)).to eq([first_neighbor.id])
    end

    it "returns none when the user has no likes" do
      user = create(:user)

      allow(RecommendationService::RedisStore).to receive(:get_similar_users).and_return(User.none)

      result = described_class.find(user, limit: 20, resource_type: "Book")

      expect(result).to eq(User.none)
    end
  end
end
