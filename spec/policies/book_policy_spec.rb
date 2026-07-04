# frozen_string_literal: true

require "rails_helper"

RSpec.describe BookPolicy, type: :policy do
  subject { described_class }

  let(:book) { build(:book) }
  let(:user) { build(:user) }
  let(:editor) { build(:user, :editor) }
  let(:guest) { nil }

  permissions :show? do
    it "grants access to guests" do
      expect(subject).to permit(guest, book)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "denies access to registered users" do
      expect(subject).not_to permit(user, book)
    end

    it "grants access to editors" do
      expect(subject).to permit(editor, book)
    end
  end

  permissions :like?, :dislike?, :manage_collections? do
    it "denies access to guests" do
      expect(subject).not_to permit(guest, book)
    end

    it "grants access to signed-in users" do
      expect(subject).to permit(user, book)
    end
  end

  permissions :featured?, :trending?, :awarded?, :latest? do
    it "grants access to guests" do
      expect(subject).to permit(guest, book)
    end
  end
end
