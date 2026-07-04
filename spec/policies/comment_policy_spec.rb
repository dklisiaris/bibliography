# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommentPolicy, type: :policy do
  subject { described_class }

  let(:author) { create(:user) }
  let(:other_user) { create(:user) }
  let(:guest) { nil }
  let(:book) { create(:book) }
  let(:comment) { Comment.create!(body: "Nice book", user: author, commentable: book) }

  permissions :create?, :new? do
    it "denies access to guests" do
      expect(subject).not_to permit(guest, comment)
    end

    it "grants access to signed-in users" do
      expect(subject).to permit(other_user, comment)
    end
  end

  permissions :update?, :edit?, :destroy? do
    it "grants access to the comment author" do
      expect(subject).to permit(author, comment)
    end

    it "denies access to other users" do
      expect(subject).not_to permit(other_user, comment)
    end
  end
end
