# frozen_string_literal: true

require "rails_helper"

RSpec.describe ViewTracker::AnalyticsAggregator do
  let(:book) { create(:book) }

  def create_impression(created_at:)
    impression = Impression.create!(
      impressionable: book,
      ip_address: "127.0.0.1",
      session_hash: SecureRandom.hex(4)
    )
    impression.update_column(:created_at, created_at)
    impression
  end

  describe ".views_over_time" do
    it "groups impressions by day using date_trunc" do
      create_impression(created_at: Time.zone.parse("2026-06-01 10:00"))
      create_impression(created_at: Time.zone.parse("2026-06-01 18:00"))
      create_impression(created_at: Time.zone.parse("2026-06-02 09:00"))

      result = described_class.views_over_time(
        book,
        duration: 1.month,
        interval: :day
      )

      day_one = Time.zone.parse("2026-06-01 00:00:00 UTC")
      day_two = Time.zone.parse("2026-06-02 00:00:00 UTC")

      expect(result[day_one]).to eq(2)
      expect(result[day_two]).to eq(1)
    end

    it "raises for unsupported intervals" do
      expect {
        described_class.views_over_time(book, interval: :year)
      }.to raise_error(ArgumentError, /Unsupported interval/)
    end
  end
end
