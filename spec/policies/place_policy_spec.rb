# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlacePolicy, type: :policy do
  subject { described_class }

  let(:user) { build(:user) }
  let(:editor) { build(:user, :editor) }
  let(:place) { create(:place) }

  permissions :index? do
    it "grants access to guests" do
      expect(subject).to permit(nil, place)
    end
  end

  permissions :show? do
    it "grants access to guests for persisted records" do
      expect(subject).to permit(nil, place)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "denies access to registered users" do
      expect(subject).not_to permit(user, place)
    end

    it "grants access to editors" do
      expect(subject).to permit(editor, place)
    end
  end
end
