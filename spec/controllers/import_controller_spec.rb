require 'rails_helper'

RSpec.describe ImportController, :type => :controller do
  let(:user) { create(:user, role: 'admin') }

  before do
    sign_in user
  end

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST import_from_text" do
    before { ActiveJob::Base.queue_adapter = :test }

    it "enqueues an import job for valid JSON content" do
      expect {
        post :import_from_text, params: { content: { "books" => [] }.to_json }
      }.to have_enqueued_job(ImportJob)

      expect(response).to redirect_to(import_path)
      expect(flash[:notice]).to be_present
    end
  end

end
