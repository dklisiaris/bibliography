# frozen_string_literal: true

module Biblionet
  # :nodoc
  class FetchLatestBooks
    include Interactor

    def call
      @last_biblionet_id = latest_biblionet_id + 1
      @limit = context.limit || 0

      empty_responses = 0
      imported_books_count = 0

      while empty_responses < 50 && imported_books_count <= @limit
        service = Biblionet::FetchBook.call(biblionet_book_id: @last_biblionet_id)

        if service.failure?
          empty_responses += 1
        else
          empty_responses = 0
        end

        @last_biblionet_id += 1
        imported_books_count += 1 if @limit != 0
      end
    end

    private

    def latest_biblionet_id
      Book.order(biblionet_id: :desc).limit(1).pluck(:biblionet_id).first || 60
    end
  end
end
