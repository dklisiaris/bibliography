# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendationService::SimilarityCalculator do
  before { allow(RecommendationService).to receive(:update_for) }

  describe ".jaccard_similarity_from_sets" do
    it "returns 0 when either set is empty" do
      expect(described_class.jaccard_similarity_from_sets([], [1, 2])).to eq(0.0)
      expect(described_class.jaccard_similarity_from_sets([1], [])).to eq(0.0)
    end

    it "returns intersection size divided by union size" do
      expect(described_class.jaccard_similarity_from_sets([1, 2, 3], [2, 3, 4])).to eq(0.5)
    end
  end

  describe ".jaccard_similarity" do
    it "returns 0 for the same user" do
      user = create(:user)

      expect(described_class.jaccard_similarity(user, user)).to eq(0.0)
    end

    it "returns 0 when users have no overlapping likes" do
      first_user = create(:user)
      second_user = create(:user)
      create(:rating, user: first_user, rateable: create(:book), rate: :like)
      create(:rating, user: second_user, rateable: create(:book), rate: :like)

      expect(described_class.jaccard_similarity(first_user, second_user)).to eq(0.0)
    end

    it "calculates similarity from shared book likes" do
      first_user = create(:user)
      second_user = create(:user)
      shared_book = create(:book)
      unique_book = create(:book)

      create(:rating, user: first_user, rateable: shared_book, rate: :like)
      create(:rating, user: first_user, rateable: unique_book, rate: :like)
      create(:rating, user: second_user, rateable: shared_book, rate: :like)

      expect(described_class.jaccard_similarity(first_user, second_user)).to eq(0.5)
    end
  end

  describe ".weighted_similarity" do
    it "rewards shared likes and shared dislikes while penalizing conflicts" do
      first_user = create(:user)
      second_user = create(:user)
      shared_like = create(:book)
      shared_dislike = create(:book)
      conflict_book = create(:book)

      create(:rating, user: first_user, rateable: shared_like, rate: :like)
      create(:rating, user: second_user, rateable: shared_like, rate: :like)
      create(:rating, user: first_user, rateable: shared_dislike, rate: :dislike)
      create(:rating, user: second_user, rateable: shared_dislike, rate: :dislike)
      create(:rating, user: first_user, rateable: conflict_book, rate: :like)
      create(:rating, user: second_user, rateable: conflict_book, rate: :dislike)

      expect(described_class.weighted_similarity(first_user, second_user)).to be_within(0.001).of(1.0 / 3.0)
    end
  end
end
