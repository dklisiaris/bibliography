require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update_content" do
    it "returns http success" do
      get :update_content
      expect(response).to have_http_status(:success)
    end
  end

end
