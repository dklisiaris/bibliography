require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #welcome_guide" do
    it "returns http success" do
      get :welcome_guide
      expect(response).to have_http_status(:success)
    end
  end

end
