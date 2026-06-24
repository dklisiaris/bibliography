# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendationService::OrderedRelation do
  describe ".where_id_in_order" do
    it "returns records in the given id order" do
      first = create(:book)
      second = create(:book)
      third = create(:book)

      result = described_class.where_id_in_order(Book, [third.id, first.id, second.id])

      expect(result.map(&:id)).to eq([third.id, first.id, second.id])
    end

    it "returns none for empty ids" do
      expect(described_class.where_id_in_order(Book, [])).to eq(Book.none)
    end

    it "ignores non-integer ids" do
      book = create(:book)
      result = described_class.where_id_in_order(Book, [book.id, "drop table", nil])

      expect(result.map(&:id)).to eq([book.id])
    end
  end
end
