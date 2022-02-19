# frozen_string_literal: true

CarrierWave.configure do |config|
  config.asset_host = 'https://bibliography.gr' if Rails.env.development?
end
