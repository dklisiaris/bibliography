# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublisherPolicy, type: :policy do
  subject { described_class }

  let(:guest) { nil }
  let(:publisher) { build(:publisher) }

  permissions :search? do
    it "grants access to guests" do
      expect(subject).to permit(guest, publisher)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "denies access to registered users" do
      expect(subject).not_to permit(build(:user), publisher)
    end

    it "grants access to editors" do
      expect(subject).to permit(build(:user, :editor), publisher)
    end
  end
end
