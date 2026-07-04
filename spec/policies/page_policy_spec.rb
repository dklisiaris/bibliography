# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagePolicy, type: :policy do
  subject { described_class }

  let(:user) { build(:user) }
  let(:guest) { nil }

  permissions :privacy_policy?, :about?, :contact? do
    it "grants access to guests" do
      expect(subject).to permit(guest, :page)
    end
  end

  permissions :welcome_guide? do
    it "denies access to guests" do
      expect(subject).not_to permit(guest, :page)
    end

    it "grants access to signed-in users" do
      expect(subject).to permit(user, :page)
    end
  end
end
