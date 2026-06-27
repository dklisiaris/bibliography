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

  describe "GET search" do
    let(:book) { create(:book) }

    def search_result_double(klass, records, total: records.size)
      instance_double(
        "Searchkick::Results",
        klass: klass,
        results: records,
        response: { "hits" => { "total" => { "value" => total } } }
      )
    end

    def stub_multi_search(results)
      allow(Searchkick).to receive(:multi_search).and_return(results)
      allow(Book).to receive(:search).and_return(results.first)
      allow(Author).to receive(:search).and_return(results.second)
      allow(Publisher).to receive(:search).and_return(results.third)
      allow(Category).to receive(:search).and_return(results.fourth)
      allow(Series).to receive(:search).and_return(results.fifth)
    end

    it "redirects to root when q is blank" do
      get :search
      expect(response).to redirect_to(root_path)
    end

    it "returns autocomplete JSON for multi-search" do
      search_results = [
        search_result_double(Book, [book]),
        search_result_double(Author, []),
        search_result_double(Publisher, []),
        search_result_double(Category, []),
        search_result_double(Series, [])
      ]
      stub_multi_search(search_results)
      allow(controller).to receive(:search_results_preview_json).and_return(
        { results: { books: [{ id: book.id, title: book.title }] } }
      )

      get :search, params: { q: "test", autocomplete: 1 }, format: :json

      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body.dig("results", "books").first["id"]).to eq(book.id)
      expect(body.dig("results", "books").first["title"]).to eq(book.title)
    end

    it "renders the search page for a normal query" do
      search_results = [
        search_result_double(Book, [book]),
        search_result_double(Author, []),
        search_result_double(Publisher, []),
        search_result_double(Category, []),
        search_result_double(Series, [])
      ]
      stub_multi_search(search_results)

      get :search, params: { q: "test" }

      expect(response).to have_http_status(:success)
      expect(assigns(:search_hits)).to include("Book" => 1)
    end
  end

  describe "GET autocomplete" do
    it "returns book title suggestions as JSON" do
      book = create(:book, title: "Odyssey")
      allow(Book).to receive(:search).with("ody", autocomplete: true, limit: 10).and_return([book])

      get :autocomplete, params: { q: "ody" }, format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(["Odyssey"])
    end
  end

end
