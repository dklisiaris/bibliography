class ContentUpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform
    target_book_id = latest_biblionet_id.to_i + 1
    empty_responses = 0

    while empty_responses < 10 do
      response = Bookshark::Extractor.new(format: 'json').book(id: target_book_id)
      response_hash = JSON.parse(response)
      
      if response_hash["book"].empty?
        empty_responses +=1
      else
        ImportWorker.perform_async(response_hash)
        empty_responses = 0
      end
      target_book_id += 1
    end

  end

  def latest_biblionet_id
    latest_book = Book.order(biblionet_id: :desc).limit(1).first
    latest_book.biblionet_id
  end

end