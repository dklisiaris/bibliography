# frozen_string_literal: true

# :nodoc
class DailyFetchBooksJob < ApplicationJob
  queue_as :maintenance

  def perform(limit = 1)
    Biblionet::FetchLatestBooks.call(limit: limit)
  end
end
