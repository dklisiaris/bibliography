class BookCoverUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(book_id)
    book = Book.find(book_id)
    if book.image.present? && book.uploaded_cover_url.nil?
      if book.update(remote_uploaded_cover_url: book.image)
        puts "Cover uploaded for book: #{book.id} - #{book.title}"
      end
    end
  end

end
