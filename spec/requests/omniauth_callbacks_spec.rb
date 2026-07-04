# frozen_string_literal: true

require "rails_helper"

# Documents expected OAuth sign-in behavior using OmniAuth test mocks.
# Production OAuth may still be broken (Turbo/credentials/provider config) — fix deferred.
# Model-level behavior: spec/models/user_omniauth_spec.rb
RSpec.describe "OAuth sign-in", :omniauth, type: :request do
  def expect_signed_in(user)
    get edit_user_registration_path
    expect(response).to have_http_status(:success)
    expect(controller.current_user).to eq(user)
  end

  describe "Facebook callback" do
    let(:auth) do
      mock_omniauth_auth(
        provider: :facebook,
        uid: "facebook-123",
        email: "oauth-facebook@example.com",
        name: "Facebook Reader"
      )
    end

    before { set_omniauth_mock(:facebook, auth) }

    it "creates a user and redirects first-time sign-ins to the welcome guide" do
      expect {
        get user_facebook_omniauth_callback_path
      }.to change(User, :count).by(1)

      user = User.find_by(provider: "facebook", uid: "facebook-123")
      expect(user).to be_present
      expect(response).to redirect_to(pages_welcome_guide_path)

      follow_redirect!
      expect(controller.current_user).to eq(user)
    end

    it "signs in returning users and redirects to root" do
      user = create(
        :user,
        provider: "facebook",
        uid: "facebook-123",
        email: "oauth-facebook@example.com",
        sign_in_count: 1
      )

      expect {
        get user_facebook_omniauth_callback_path
      }.not_to change(User, :count)

      expect(response).to redirect_to(root_path)
      expect_signed_in(user)
    end
  end

  describe "Google callback" do
    let(:auth) do
      mock_omniauth_auth(
        provider: :google_oauth2,
        uid: "google-456",
        email: "oauth-google@example.com",
        name: "Google Reader"
      )
    end

    before { set_omniauth_mock(:google_oauth2, auth) }

    it "creates a user and redirects first-time sign-ins to the welcome guide" do
      expect {
        get user_google_oauth2_omniauth_callback_path
      }.to change(User, :count).by(1)

      user = User.find_by(provider: "google_oauth2", uid: "google-456")
      expect(user).to be_present
      expect(response).to redirect_to(pages_welcome_guide_path)

      follow_redirect!
      expect(controller.current_user).to eq(user)
    end

    it "signs in returning users and redirects to root" do
      user = create(
        :user,
        provider: "google_oauth2",
        uid: "google-456",
        email: "oauth-google@example.com",
        sign_in_count: 1
      )

      expect {
        get user_google_oauth2_omniauth_callback_path
      }.not_to change(User, :count)

      expect(response).to redirect_to(root_path)
      expect_signed_in(user)
    end
  end

  describe "failure callback" do
    it "redirects to root when the provider returns invalid credentials" do
      set_omniauth_mock(:facebook, :invalid_credentials)

      get user_facebook_omniauth_callback_path

      expect(response).to redirect_to(root_path)
    end
  end
end
