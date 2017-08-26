# Elasticsearch configuration.

# Increase timeout.
Searchkick.timeout = 60

# Searchkick.client = Elasticsearch::Client.new(url: ENV["ELASTICSEARCH_URL"], retry_on_failure: 5)

Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL'] || "localhost:9200"

Searchkick.client_options = {
  retry_on_failure: true
}

# Use typhoeus for http requests instead of the default Net::HTTP
# require "typhoeus/adapters/faraday"
Ethon.logger = Logger.new("/dev/null")
