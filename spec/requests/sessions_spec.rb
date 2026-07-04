# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User sign out", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  it "signs out via DELETE" do
    delete destroy_user_session_path

    expect(response).to redirect_to(root_path)

    get edit_user_registration_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it "does not sign out via GET" do
    expect {
      get destroy_user_session_path
    }.to raise_error(ActionController::RoutingError, /No route matches/)
  end
end
