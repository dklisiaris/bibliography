# Elasticsearch configuration.

# Increase timeout.
Searchkick.timeout = 60

# Use typhoeus for http requests instead of the default Net::HTTP
require "typhoeus/adapters/faraday"
Ethon.logger = Logger.new("/dev/null")