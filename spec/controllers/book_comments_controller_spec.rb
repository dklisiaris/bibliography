# frozen_string_literal: true

require "rails_helper"

RSpec.describe BookCommentsController, type: :controller do
  let(:user) { create(:user, api_key: "test-api-key") }
  let(:book) { create(:book) }

  before do
    authenticate_with_api_token(user)
  end

  describe "POST create" do
    it "creates a comment and returns JSON" do
      expect {
        post :create, params: { book_id: book.id, comment: { body: "Great read" } }, format: :json
      }.to change(Comment, :count).by(1)

      body = JSON.parse(response.body)
      expect(body.dig("comment", "message")).to eq("ok")
      expect(body.dig("comment", "body")).to eq("Great read")
      expect(body.dig("comment", "user", "id")).to eq(user.id)
    end
  end

  describe "DELETE destroy" do
    it "deletes the user's comment" do
      comment = Comment.create!(commentable: book, user: user, body: "Remove me")

      expect {
        delete :destroy, params: { book_id: book.id, id: comment.id }, format: :json
      }.to change(Comment, :count).by(-1)

      body = JSON.parse(response.body)
      expect(body["message"]).to eq("ok")
    end
  end
end
