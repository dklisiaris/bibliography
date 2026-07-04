# frozen_string_literal: true

require "rails_helper"

RSpec.describe PreviewJson, type: :controller do
  controller(ActionController::Base) do
    include PreviewJson
    include Rails.application.routes.url_helpers

    def default_url_options
      { host: "test.host" }
    end

    def index
      render json: preview_json([Book.find(params[:book_id])], :book)
    end
  end

  before do
    routes.draw { get "index" => "anonymous#index" }
  end

  it "dispatches to private preview helpers without public_send errors" do
    book = create(:book)

    get :index, params: { book_id: book.id }, format: :json

    expect(response).to have_http_status(:success)
    body = JSON.parse(response.body)
    expect(body.first["id"]).to eq(book.id)
    expect(body.first["title"]).to eq(book.title)
  end
end
