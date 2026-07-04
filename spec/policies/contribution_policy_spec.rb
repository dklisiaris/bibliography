# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContributionPolicy, type: :policy do
  subject { described_class }

  let(:editor) { build(:user, :editor) }
  let(:user) { build(:user) }
  let(:contribution) { build(:contribution) }

  permissions :index? do
    it "denies access to everyone" do
      expect(subject).not_to permit(editor, contribution)
      expect(subject).not_to permit(user, contribution)
      expect(subject).not_to permit(nil, contribution)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "grants access to editors" do
      expect(subject).to permit(editor, contribution)
    end

    it "denies access to registered users" do
      expect(subject).not_to permit(user, contribution)
    end
  end

  describe "Scope" do
    subject { described_class::Scope.new(user, Contribution.all).resolve }

    let!(:contribution) { create(:contribution) }

    context "as editor" do
      let(:user) { create(:user, :editor) }

      it "includes all contributions" do
        expect(subject).to include(contribution)
      end
    end

    context "as registered user" do
      let(:user) { create(:user) }

      it "returns no contributions" do
        expect(subject).to be_empty
      end
    end
  end
end
