require 'faraday'
require 'faraday_middleware' # TODO: use autoload, we only need EncodeJson
require 'faraday-http-cache'

# faraday-http-cache is a great gem that correctly ignores Private Cache
# For the sake of saving Github calls, let's cache Private as well!
module Faraday
  class HttpCache
    class CacheControl
      def private?
        false
      end
    end
  end
end

require 'rspec-api/http/remote/resource'
require 'rspec-api/http/remote/route'
require 'rspec-api/http/remote/request'

RSpec.configuration.include Http::Remote::Resource, rspec_api_dsl: :resource
RSpec.configuration.include Http::Remote::Request, rspec_api_dsl: :request
RSpec.configuration.include Http::Remote::Route, rspec_api_dsl: :route