class ContentUpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(limit=0)
    target_book_id = latest_biblionet_id.to_i + 1
    empty_responses = 0
    imported_books_count = 0

    while empty_responses < 10 && imported_books_count <= limit do
      response = Bookshark::Extractor.new(format: 'json').book(id: target_book_id)
      response_hash = JSON.parse(response)

      if response_hash["book"].empty?
        empty_responses +=1
      else
        ImportWorker.perform_async(response_hash)
        empty_responses = 0
      end
      target_book_id += 1
      imported_books_count +=1 if limit != 0
    end

  end

  def latest_biblionet_id
    latest_book = Book.order(biblionet_id: :desc).limit(1).first
    if latest_book
      latest_book.biblionet_id
    else
      return 60 if Book.count == 0
    end
  end

end
