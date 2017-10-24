class BookOfTheDayPublisherWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(daily_suggestion_id=nil)
    if daily_suggestion_id.nil?
      current_suggestion = DailySuggestion.get_current_suggestion
    else
      current_suggestion = DailySuggestion.find(daily_suggestion_id)
    end
    book_of_the_day = current_suggestion.book
    suggested_at = current_suggestion.suggested_at

    unless book_of_the_day.cover_og == "/no_cover.jpg"
      RestClient::Request.execute(method: :post, url: "https://graph.facebook.com/1964445657164530/feed",
        payload: {
          message: "Βιβλίο της #{I18n.l(suggested_at, format: "%a, %d %b %Y")}\r\n---\r\n#{book_of_the_day.title}\r\n---\r\n#{book_of_the_day.short_description}",
          link: "https://bibliography.gr/books/#{book_of_the_day.slug}",
          access_token: Rails.application.secrets.FACEBOOK_ACCESS_TOKEN
        })
    end
  end

end
