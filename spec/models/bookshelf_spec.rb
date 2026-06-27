# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bookshelf, type: :model do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:shelf) { user.shelves.first }

  describe ".add_book_to_multiple_bookshelves" do
    it "adds a book to the user's shelf" do
      expect {
        described_class.add_book_to_multiple_bookshelves(book.id, [shelf.id], user)
      }.to change { described_class.where(book: book, shelf: shelf).count }.by(1)
    end

    it "ignores shelf ids that do not belong to the user" do
      other_shelf = create(:shelf)

      expect {
        described_class.add_book_to_multiple_bookshelves(book.id, [other_shelf.id], user)
      }.not_to change(described_class, :count)
    end
  end

  describe ".remove_book_from_multiple_bookshelves" do
    it "removes a book from the user's shelf" do
      described_class.create!(book: book, shelf: shelf)

      expect {
        described_class.remove_book_from_multiple_bookshelves(book.id, [shelf.id], user)
      }.to change { described_class.where(book: book, shelf: shelf).count }.by(-1)
    end
  end
end
