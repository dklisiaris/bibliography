# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoryPolicy, type: :policy do
  subject { described_class }

  let(:user) { build(:user) }
  let(:guest) { nil }
  let(:category) { build(:category) }

  permissions :show? do
    it "grants access to guests" do
      expect(subject).to permit(guest, category)
    end
  end

  permissions :favourite? do
    it "denies access to guests" do
      expect(subject).not_to permit(guest, category)
    end

    it "grants access to signed-in users" do
      expect(subject).to permit(user, category)
    end
  end
end
