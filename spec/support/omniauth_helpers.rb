# frozen_string_literal: true

module OmniauthHelpers
  def mock_omniauth_auth(provider:, uid:, email:, name: "OAuth User", image: "https://example.com/avatar.jpg")
    OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: uid.to_s,
      info: OmniAuth::AuthHash::InfoHash.new(
        email: email,
        name: name,
        image: image
      )
    )
  end

  def set_omniauth_mock(provider, auth_hash)
    OmniAuth.config.mock_auth[provider.to_sym] = auth_hash
  end

  def clear_omniauth_mocks
    OmniAuth.config.mock_auth[:facebook] = nil
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end
end

RSpec.configure do |config|
  config.include OmniauthHelpers, type: :request
  config.include OmniauthHelpers, type: :model

  config.before(:each, :omniauth) do
    OmniAuth.config.test_mode = true
    clear_omniauth_mocks
  end

  config.after(:each, :omniauth) do
    OmniAuth.config.test_mode = false
    clear_omniauth_mocks
  end
end
