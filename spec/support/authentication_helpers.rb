# frozen_string_literal: true

# Authentication helpers for tests
# Provides sign_in and sign_out methods for controller and request specs

module AuthenticationHelpers
  def sign_in(user)
    # Devise test helper - available in controller and request specs
    if respond_to?(:sign_in)
      super(user)
    else
      # For request specs, use Warden test helpers
      login_as(user, scope: :user)
    end
  end

  def sign_out
    if respond_to?(:sign_out)
      super(:user)
    else
      logout(:user)
    end
  end

  def sign_in_as(user)
    sign_in(user)
    user
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :controller
  config.include AuthenticationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
end

