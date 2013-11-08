require File.expand_path("../../../../spec/dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'rack/test'

def app
  Rails.application
end

module RSpecApi
  module DSL
    module HttpClient
      include Rack::Test::Methods

      def ciao

      end

      def send_request(verb, route, body, authorization)
        header 'Accept', 'application/json'
        send verb, route, body
      end

      def response
        last_response
      end
    end
  end
end