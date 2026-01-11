require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user, role: 'admin') }

  before do
    sign_in user
    # Stub DailySuggestion to avoid database queries
    daily_suggestion = double("DailySuggestion",
      suggested_at: Time.current,
      book: create(:book)
    )
    allow(DailySuggestion).to receive(:get_current_suggestion).and_return(daily_suggestion)
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update_content" do
    it "redirects to tasks path" do
      get :update_content
      expect(response).to redirect_to(tasks_path)
    end
  end

end
