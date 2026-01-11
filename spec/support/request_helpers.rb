# frozen_string_literal: true

# Request helpers for API testing
# Provides JSON parsing and API header helpers

module RequestHelpers
  def json_response
    JSON.parse(response.body)
  rescue JSON::ParserError
    {}
  end

  def api_headers(user = nil)
    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    if user && user.respond_to?(:api_key) && user.api_key.present?
      headers['Authorization'] = "Bearer #{user.api_key}"
    end
    headers
  end

  def api_get(path, user: nil, params: {})
    get path, params: params, headers: api_headers(user)
  end

  def api_post(path, user: nil, params: {})
    post path, params: params.to_json, headers: api_headers(user)
  end

  def api_put(path, user: nil, params: {})
    put path, params: params.to_json, headers: api_headers(user)
  end

  def api_delete(path, user: nil)
    delete path, headers: api_headers(user)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end

