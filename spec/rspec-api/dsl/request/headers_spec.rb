require 'spec_helper'
require 'ostruct'
require 'rspec-api/dsl/request/headers'
RSpec.configuration.include DSL::Request # should have RSpecApi prefix ?!

describe 'should_respond_with_expected_headers' do
  let(:request_params) { {} }
  let(:response) { OpenStruct.new status: 200, headers: {}, body: ''  }

  # e.g.: DELETE /
  context 'given an empty request and a response with no content' do
    before { response.status = 204 }
    should_respond_with_expected_headers
  end

  # e.g.: GET /
  context 'given an empty request and a response with JSON content' do
    before { response.headers['Content-Type'] = 'application/json; charset=utf-8' }
    should_respond_with_expected_headers
  end

  # e.g.: GET /?page=2 + accepts_page :page_number
  context 'given a request with a page parameter and a paginated response with JSON content' do
    before { response.headers['Content-Type'] = 'application/json; charset=utf-8' }
    before { request_params['page_number'] = 2 }
    before { response.headers['Link'] = '<http://example.com/1>; rel="prev"' }
    should_respond_with_expected_headers page: :page_number
  end
  # TODO: Manage failing expectations
end