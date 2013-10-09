require 'faraday'
require 'faraday_middleware' # use autoload, we only need EncodeJson
require 'faraday-http-cache-ignoring-private'

module DSL
  module ActiveResource
    module Route
      extend ActiveSupport::Concern

      def send_request(verb, route, body)
        logger = Logger.new 'log/faraday.log'

        conn = Faraday.new 'https://api.github.com/' do |c|
          # NOTE: The order is **important**! Leave HttpCache first
          c.use Faraday::HttpCache, store: :file_store, store_options: ['/tmp/faraday'], logger: logger
          c.use FaradayMiddleware::EncodeJson # query params are not JSON(body) but data are
          c.use Faraday::Response::Logger, logger
          c.use Faraday::Adapter::NetHttp
        end

        conn.headers[:user_agent] = 'RSpec API for Github'
        conn.authorization *authorization.flatten

        @last_response = conn.send verb, route, body do |request|
          @last_request = request
        end
      end

      def authorization
        # TODO: Any other way to access metadata in a before(:all) ?
        self.class.metadata[:rspec_api][:authorization]
      end

      module ClassMethods

        def setup_fixtures
          # nothing to do for now...
        end

        def existing(field)
          case field
          when :user then 'claudiob'
          when :gist_id then '0d7b597d822102148810'
          when :starred_gist_id then '1e31c19a5fb3c5330193'
          when :unstarred_gist_id then '5cf0b36e301262a09b30'
          when :someone_elses_gist_id then 'ca832349ffb06c19d424'
          when :id then '921225'
          when :updated_at then '2013-10-07T10:10:10Z' # TODO use helpers
          end
        end

        def unknown(field)
          case field
          when :user then 'not-a-valid-user'
          when :gist_id then 'not-a-valid-gist-id'
          when :id then 'not-a-valid-id'
          end
        end
      end
    end
  end
end


module DSL
  module ActiveResource
    module Resource
      extend ActiveSupport::Concern

      module ClassMethods
        def authorize_with(options = {})
          rspec_api[:authorization] = options
        end
      end
    end
  end
end


module DSL
  module ActiveResource
    module Request
      extend ActiveSupport::Concern

      def response
        @last_response
      end

      def request_params
        @last_request.params
      end
    end
  end
end

RSpec.configuration.include DSL::ActiveResource::Resource, rspec_api_dsl: :resource
RSpec.configuration.include DSL::ActiveResource::Request, rspec_api_dsl: :request
RSpec.configuration.include DSL::ActiveResource::Route, rspec_api_dsl: :route