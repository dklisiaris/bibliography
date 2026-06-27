# frozen_string_literal: true

require "rails_helper"

RSpec.describe ViewTracker::DuplicateChecker do
  let(:book) { create(:book) }
  let(:user) { create(:user) }

  def create_impression(**attrs)
    Impression.create!(
      {
        impressionable: book,
        ip_address: "127.0.0.1",
        session_hash: "session-1"
      }.merge(attrs)
    )
  end

  describe ".duplicate?" do
    it "returns true when the same user viewed recently" do
      create_impression(user_id: user.id, created_at: 30.minutes.ago)

      expect(described_class.duplicate?(
        resource: book,
        ip: "10.0.0.1",
        session_hash: "other-session",
        user: user
      )).to be(true)
    end

    it "returns true when the same session viewed recently" do
      create_impression(session_hash: "session-abc", created_at: 30.minutes.ago)

      expect(described_class.duplicate?(
        resource: book,
        ip: "10.0.0.2",
        session_hash: "session-abc",
        user: nil
      )).to be(true)
    end

    it "returns true when the same IP viewed within five minutes" do
      create_impression(ip_address: "203.0.113.10", created_at: 2.minutes.ago)

      expect(described_class.duplicate?(
        resource: book,
        ip: "203.0.113.10",
        session_hash: "fresh-session",
        user: nil
      )).to be(true)
    end

    it "returns false when prior views are outside the dedupe windows" do
      create_impression(
        user_id: user.id,
        session_hash: "session-old",
        ip_address: "203.0.113.10",
        created_at: 2.hours.ago
      )

      expect(described_class.duplicate?(
        resource: book,
        ip: "203.0.113.10",
        session_hash: "session-old",
        user: user
      )).to be(false)
    end

    it "checks duplicate status with one database query" do
      book = build_stubbed(:book)
      user = build_stubbed(:user)
      queries = []
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*, payload|
        next if payload[:name] == "SCHEMA"

        queries << payload[:sql]
      end

      described_class.duplicate?(
        resource: book,
        ip: "127.0.0.1",
        session_hash: "session-1",
        user: user
      )
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber)
      expect(queries.grep(/FROM "impressions"/i).size).to eq(1)
    end
  end
end
