require 'rack/test'
require 'rspec-api/http/local/route'
require 'rspec-api/http/local/request'

def app
  Rails.application
end

RSpec.configuration.include Rack::Test::Methods, rspec_api_dsl: :route
RSpec.configuration.include Http::Local::Route, rspec_api_dsl: :route
RSpec.configuration.include Http::Local::Request, rspec_api_dsl: :request