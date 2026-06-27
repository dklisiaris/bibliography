# frozen_string_literal: true

require "rails_helper"

RSpec.describe ViewTracker::CounterCacheUpdater do
  let(:book) { create(:book) }

  def create_impression
    Impression.create!(
      impressionable: book,
      ip_address: "127.0.0.1",
      session_hash: "session-1"
    )
  end

  describe ".increment" do
    it "atomically increases impressions_count" do
      create_impression
      book.update_column(:impressions_count, 1)

      expect {
        described_class.increment(book)
      }.to change { book.reload.impressions_count }.from(1).to(2)
    end
  end

  describe ".update" do
    it "recalculates impressions_count from stored impressions" do
      2.times { create_impression }
      book.update_column(:impressions_count, 0)

      described_class.update(book)

      expect(book.reload.impressions_count).to eq(2)
    end
  end
end
