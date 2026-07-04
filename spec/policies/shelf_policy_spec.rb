# frozen_string_literal: true

require "rails_helper"

RSpec.describe ShelfPolicy, type: :policy do
  subject { described_class }

  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let(:guest) { nil }
  let(:shelf) { create(:shelf, user: owner) }
  let(:built_in_shelf) { create(:shelf, user: owner, built_in: true) }

  permissions :show?, :update?, :edit? do
    it "grants access to the shelf owner" do
      expect(subject).to permit(owner, shelf)
    end

    it "denies access to other users when profile is private" do
      owner.profile.update!(privacy: :is_private)
      expect(subject).not_to permit(other_user, shelf)
    end

    it "grants access to other users when owner profile is public" do
      owner.profile.update!(privacy: :is_public)
      expect(subject).to permit(other_user, shelf)
    end
  end

  permissions :destroy? do
    it "grants access to the owner for user-created shelves" do
      expect(subject).to permit(owner, shelf)
    end

    it "denies destroying built-in shelves" do
      expect(subject).not_to permit(owner, built_in_shelf)
    end
  end

  permissions :public_shelves? do
    it "grants access when record is a symbol" do
      expect(subject).to permit(guest, :shelf)
    end
  end

  describe "Scope" do
    subject { described_class::Scope.new(owner, Shelf.all).resolve }

    let!(:own_shelf) { create(:shelf, user: owner) }
    let!(:other_shelf) { create(:shelf, user: other_user) }

    it "includes only the current user's shelves" do
      expect(subject).to include(own_shelf)
      expect(subject).not_to include(other_shelf)
    end
  end
end
