# frozen_string_literal: true

require "rails_helper"

RSpec.describe HomePolicy, type: :policy do
  subject { described_class }

  let(:home) { :home }

  permissions :index? do
    it "grants access to guests" do
      expect(subject).to permit(nil, home)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "denies access to registered users" do
      expect(subject).not_to permit(build(:user), home)
    end

    it "grants access to editors" do
      expect(subject).to permit(build(:user, :editor), home)
    end
  end
end
