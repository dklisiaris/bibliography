# frozen_string_literal: true

# :nodoc
class FetchBookJob < ApplicationJob
  queue_as :maintenance

  def perform(biblionet_book_id)
    Biblionet::FetchBook.call(biblionet_book_id: biblionet_book_id)
  end
end
