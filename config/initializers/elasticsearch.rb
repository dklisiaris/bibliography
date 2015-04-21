# Elasticsearch configuration.

# Increase timeout.
Searchkick.timeout = 60

Searchkick.client = Elasticsearch::Client.new(url: ENV["ELASTICSEARCH_URL"], retry_on_failure: 5)

# Use typhoeus for http requests instead of the default Net::HTTP
require "typhoeus/adapters/faraday"
Ethon.logger = Logger.new("/dev/null")