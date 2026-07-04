# frozen_string_literal: true

require "rails_helper"

RSpec.describe AwardPolicy, type: :policy do
  subject { described_class }

  let(:editor) { build(:user, :editor) }
  let(:user) { build(:user) }
  let(:award) { build(:award) }

  permissions :index?, :show? do
    it "grants access to editors" do
      expect(subject).to permit(editor, award)
    end

    it "denies access to registered users" do
      expect(subject).not_to permit(user, award)
    end
  end
end
