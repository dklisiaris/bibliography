# frozen_string_literal: true

module ApiTokenHelpers
  def api_token_headers(user, token = "test-api-key")
    user.update_column(:api_key, token) if user.api_key.blank?

    {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Token.encode_credentials(
        token,
        email: user.email
      )
    }
  end

  def authenticate_with_api_token(user, token = "test-api-key")
    sign_out(:user) if respond_to?(:sign_out)
    request.env.merge!(api_token_headers(user, token))
  end
end

RSpec.configure do |config|
  config.include ApiTokenHelpers, type: :controller
  config.include ApiTokenHelpers, type: :request
end
