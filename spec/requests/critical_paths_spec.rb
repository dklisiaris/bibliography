# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Critical path JSON endpoints", type: :request do
  let(:user) { create(:user) }

  before do
    user.update_column(:api_key, "test-api-key")
  end

  def auth_headers
    {
      "Authorization" => ActionController::HttpAuthentication::Token.encode_credentials(
        "test-api-key",
        email: user.email
      )
    }
  end

  describe "GET /books/rated_ids" do
    it "returns liked and disliked book ids for the token user" do
      liked_book = create(:book)
      disliked_book = create(:book)
      create(:rating, user: user, rateable: liked_book, rate: :like)
      create(:rating, user: user, rateable: disliked_book, rate: :dislike)

      get "/books/rated_ids", headers: auth_headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["liked_book_ids"]).to include(liked_book.id)
      expect(body["disliked_book_ids"]).to include(disliked_book.id)
    end
  end

  describe "GET /categories/liked_with_books" do
    it "returns liked categories with preview books" do
      category = create(:category)
      book = create(:book, image: "cover.jpg")
      book.categories << category
      create(:rating, user: user, rateable: category, rate: :like)

      get "/categories/liked_with_books", headers: auth_headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["categories"].first["id"]).to eq(category.id)
      expect(body["categories"].first["books"].first["id"]).to eq(book.id)
    end
  end

  describe "POST /books/:id/comments" do
    let(:book) { create(:book) }

    it "creates a comment via token auth" do
      expect {
        post "/books/#{book.id}/comments",
             params: { comment: { body: "Great read" } },
             headers: auth_headers
      }.to change(Comment, :count).by(1)

      body = JSON.parse(response.body)
      expect(body.dig("comment", "message")).to eq("ok")
    end
  end
end
