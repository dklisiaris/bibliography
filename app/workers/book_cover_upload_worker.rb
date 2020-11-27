# frozen_string_literal: true

# :nodoc
class BookCoverUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(book_id)
    book = Book.find(book_id)
    return unless book.image.present? && book.uploaded_cover_url.nil?

    updated = book.update(remote_uploaded_cover_url: book.image)
    puts "Cover uploaded for book: #{book.id} - #{book.title}" if updated
    book.update(image: nil) if !updated && book.errors[:uploaded_cover].present?
  end
end
