require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET #welcome_guide" do
    it "returns http success" do
      get :welcome_guide
      expect(response).to have_http_status(:success)
    end
  end

end
