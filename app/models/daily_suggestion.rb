class DailySuggestion < ActiveRecord::Base
  validates :book_id, presence: true, uniqueness: true

  belongs_to :book

  def self.best_match_by_title_and_author(book_title, author_name)
    # Get author's full name in our DB
    author_results = Author.search(author_name).results
    author = author_results.present? ? author_results.first.fullname : author_name

    results = Book.search(book_title, where: {author: author},
      order: {_score: :desc, has_image: :desc, publication_year: :desc}).results

    return nil if results.count == 0
    return results.first if results.count == 1

    results.each do |book|
      return book if book.description.present?
    end
    return results.first
  end

  def self.store_suggestion(book)
    self.create(book_id: book.id)
  end

  def self.pick_suggestion
    self.order(:suggested_count).order("RANDOM()").limit(1).take
  end

  def self.set_book_of_the_day
    suggested = pick_suggestion
    suggested.update(suggested_at: DateTime.now)
    suggested.increment!(:suggested_count)
  end

  def self.get_current_suggestion
    self.where.not(suggested_at: nil).order(suggested_at: :desc).limit(1).take
  end

  def self.get_book_of_the_day
    get_current_suggestion.book
  end

  def self.get_book_of_the_day_cached
    Rails.cache.fetch("get_book_of_the_day", expires_in: 1.day) do
      get_current_suggestion.book
    end
  end


end
