# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthorPolicy, type: :policy do
  subject { described_class }

  let(:user) { build(:user) }
  let(:guest) { nil }
  let(:author) { build(:author) }

  permissions :favourite? do
    it "denies access to guests" do
      expect(subject).not_to permit(guest, author)
    end

    it "grants access to signed-in users" do
      expect(subject).to permit(user, author)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "denies access to registered users" do
      expect(subject).not_to permit(user, author)
    end

    it "grants access to editors" do
      expect(subject).to permit(build(:user, :editor), author)
    end
  end
end
