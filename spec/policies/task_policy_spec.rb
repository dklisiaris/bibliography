# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskPolicy, type: :policy do
  subject { described_class }

  let(:admin) { build(:user, :admin) }
  let(:user) { build(:user) }

  permissions :index? do
    it "grants access to admins" do
      expect(subject).to permit(admin, :task)
    end

    it "denies access to registered users" do
      expect(subject).not_to permit(user, :task)
    end
  end
end
