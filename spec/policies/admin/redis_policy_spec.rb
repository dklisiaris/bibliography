# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::RedisPolicy, type: :policy do
  subject { described_class }

  let(:admin) { build(:user, :admin) }
  let(:editor) { build(:user, :editor) }
  let(:user) { build(:user) }

  permissions :index?, :show?, :destroy?, :stats? do
    it "grants access to admins" do
      expect(subject).to permit(admin, :redis)
    end

    it "denies access to editors" do
      expect(subject).not_to permit(editor, :redis)
    end

    it "denies access to registered users" do
      expect(subject).not_to permit(user, :redis)
    end
  end
end
