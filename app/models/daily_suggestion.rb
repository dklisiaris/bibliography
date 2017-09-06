class DailySuggestion < ActiveRecord::Base
  validates :book_id, presence: true, uniqueness: true

  belongs_to :book

  def self.best_match_by_title(book_title)
    results = Book.search(book_title, where: {author: "James Joyce"},
      order: {_score: :desc, has_image: :desc, publication_year: :desc}).results
    return nil if results.count == 0
    return results.first if results.count == 1

    results.each do |book|
      return book if b.description.present?
    end
    return results.first
  end

  def self.store_suggestion(book)
    self.create(book_id: book.id)
  end
end
