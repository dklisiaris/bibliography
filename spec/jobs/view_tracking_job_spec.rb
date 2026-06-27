# frozen_string_literal: true

require "rails_helper"

RSpec.describe ViewTrackingJob, type: :job do
  let(:book) { create(:book) }

  describe "#perform" do
    it "creates an impression and increments impressions_count" do
      expect {
        described_class.perform_now(
          impressionable_type: "Book",
          impressionable_id: book.id,
          user_id: nil,
          ip_address: "127.0.0.1",
          session_hash: "session-1",
          request_hash: "abc123",
          controller_name: "books",
          action_name: "show"
        )
      }.to change { Impression.count }.by(1)
        .and change { book.reload.impressions_count }.by(1)
    end

    it "does nothing when the resource no longer exists" do
      expect {
        described_class.perform_now(
          impressionable_type: "Book",
          impressionable_id: 999_999,
          ip_address: "127.0.0.1"
        )
      }.not_to change { Impression.count }
    end
  end
end
