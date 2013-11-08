require 'faraday'
require 'faraday_middleware' # TODO: use autoload, we only need EncodeJson
require 'faraday-http-cache'
require 'logger'

module Authorize
  def authorize_with(options = {})
    @authorization = options
  end
end

module RSpecApi
  module DSL
    module HttpClient
      def send_request(verb, route, body, authorization)
        logger = Logger.new 'log/faraday.log'

        conn = Faraday.new 'https://api.github.com/' do |c| # TODO: Pass host as a parameter
          # NOTE: The order is **important**! Leave HttpCache first
          c.use Faraday::HttpCache, serializer: Marshal, store: :file_store, store_options: ['/tmp/faraday'], logger: logger
          c.use FaradayMiddleware::EncodeJson # query params are not JSON(body) but data are
          c.use Faraday::Response::Logger, logger
          c.use Faraday::Adapter::NetHttp
        end

        conn.headers[:user_agent] = 'RSpec API'
        conn.authorization *authorization.flatten
        sleep 0.5 # TODO: Pass as a parameter

        @last_response = conn.send verb, route, body do |request|
          @last_request = request
        end
      end

      def last_response
        @last_response
      end
    end
  end
end