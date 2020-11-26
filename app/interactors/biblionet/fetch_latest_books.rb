# frozen_string_literal: true

module Biblionet
  # :nodoc
  class FetchLatestBooks
    include Interactor

    def call
      @start_id = latest_biblionet_id + 1
      @limit = context.limit || 0
      @end_id = @start_id + @limit

      (@start_id..@end_id).to_a.each do |b_id|
        FetchBookJob.perform_later(b_id)
      end
    end

    private

    def latest_biblionet_id
      Book.order(biblionet_id: :desc).limit(1).pluck(:biblionet_id).first || 60
    end
  end
end
