# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfilePolicy, type: :policy do
  subject { described_class }

  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let(:guest) { nil }
  let(:profile) { owner.profile }

  permissions :show? do
    it "grants access to the profile owner" do
      expect(subject).to permit(owner, profile)
    end

    it "grants access to guests for public profiles" do
      profile.update!(privacy: :is_public, username: "publicuser")
      expect(subject).to permit(guest, profile)
    end

    it "denies access to guests for private profiles" do
      profile.update!(privacy: :is_private)
      expect(subject).not_to permit(guest, profile)
    end
  end

  permissions :update?, :edit? do
    it "grants access to the profile owner" do
      expect(subject).to permit(owner, profile)
    end

    it "denies access to other users" do
      expect(subject).not_to permit(other_user, profile)
    end
  end

  permissions :follow? do
    before { profile.update!(privacy: :is_public, username: "followme") }

    it "denies access to guests" do
      expect(subject).not_to permit(guest, profile)
    end

    it "grants access to signed-in users for public profiles" do
      expect(subject).to permit(other_user, profile)
    end
  end
end
