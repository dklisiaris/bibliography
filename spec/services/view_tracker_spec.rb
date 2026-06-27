require "rails_helper"

RSpec.describe ViewTracker do
  let(:book) { create(:book) }
  let(:request) do
    double(
      "request",
      remote_ip: "127.0.0.1",
      session: double(id: "123"),
      params: { controller: "books", action: "show" },
      referer: nil,
      user_agent: "Mozilla"
    )
  end
  let(:user) { create(:user) }

  describe ".track" do
    it "creates an impression" do
      expect {
        ViewTracker.track(book, request: request, user: user, async: false)
      }.to change { Impression.count }.by(1)
    end

    it "updates impressions_count" do
      expect {
        ViewTracker.track(book, request: request, user: user, async: false)
      }.to change { book.reload.impressions_count }.by(1)
    end

    it "always increments views_count even when the impression is deduplicated" do
      ViewTracker.track(book, request: request, user: user, async: false)

      expect {
        ViewTracker.track(book, request: request, user: user, async: false)
      }.to change { book.reload.views_count }.by(1)

      expect(Impression.count).to eq(1)
    end

    it "prevents duplicate impressions" do
      ViewTracker.track(book, request: request, user: user, async: false)

      expect {
        ViewTracker.track(book, request: request, user: user, async: false)
      }.not_to change { Impression.count }
    end

    it "enqueues a background job when async is enabled" do
      ActiveJob::Base.queue_adapter = :test

      expect {
        ViewTracker.track(book, request: request, user: user, async: true)
      }.to have_enqueued_job(ViewTrackingJob)
    end
  end
end
