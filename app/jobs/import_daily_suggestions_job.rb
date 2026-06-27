# frozen_string_literal: true

class ImportDailySuggestionsJob < MaintenanceJob
  def perform(raw_import_data)
    parse_import_data(raw_import_data).each do |entry|
      book = DailySuggestion.best_match_by_title_and_author(entry[:title], entry[:author])
      if DailySuggestion.store_suggestion(book)
        Rails.logger.info "Candidate for Book of the Day: #{book.id} - #{book.title}"
      else
        Rails.logger.warn "FAILED to store: #{entry[:title]} - #{entry[:author]}"
      end
    end
  end

  private

  def parse_import_data(entries)
    entries.split("\r\n").map do |entry|
      title_and_author = entry.split("|").map(&:strip)
      { title: title_and_author[0], author: title_and_author[1] }
    end
  end
end
