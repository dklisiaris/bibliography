require 'rails_helper'

RSpec.describe HomeController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      # Create a book and daily suggestion to avoid ActiveRecord::RecordNotFound
      book = create(:book)
      DailySuggestion.create!(book_id: book.id, suggested_at: Time.current)
      
      # Clear cache to ensure fresh lookup
      Rails.cache.delete("get_book_of_the_day_id")
      Rails.cache.delete("get_book_of_the_day")
      
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
