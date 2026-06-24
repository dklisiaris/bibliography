# Elasticsearch configuration.

# Typhoeus adapter for Faraday 2.x (replaces typhoeus/adapters/faraday from Faraday 1.x)
require "faraday/typhoeus"
Ethon.logger = Logger.new("/dev/null")

# Increase timeout.
Searchkick.timeout = 60

Searchkick.client = Elasticsearch::Client.new(
  url: ENV["ELASTICSEARCH_URL"],
  retry_on_failure: 5,
  adapter: :typhoeus
)
