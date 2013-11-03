require 'spec_helper'
require 'ostruct'
require 'rspec-api/dsl/request/body'
RSpec.configuration.include DSL::Request # should have RSpecApi prefix ?!

describe 'should_respond_with_expected_body' do
  let(:request_params) { {} }
  let(:response) { OpenStruct.new status: 200, headers: {}, body: ''  }

  # e.g.: GET /
  context 'given any request and a response with an empty-body status' do
    before { response.status = 204 }
    should_respond_with_expected_body
  end

  # e.g.: GET /
  context 'given an empty request and a JSON object response' do
    before { response.body = '{"id":1}' }
    should_respond_with_expected_body
  end

  # e.g.: GET / + array: true
  context 'given a request with an array parameter and a JSON array response' do
    before { response.body = '[{"id":1},{"id":2}]' }
    should_respond_with_expected_body type: Array
  end

  # e.g.: GET /?fun=alert + accepts_callback :fun
  context 'given a request with a callback parameter and a JSONP response' do
    before { request_params['fun'] = 'alert' }
    before { response.body = 'alert({"id":1,"flag":true})' }
    should_respond_with_expected_body callbacks: [{name: 'fun', value: 'alert'}]
  end

  # e.g.: GET /?sort=id + accepts_sort :id, by: :uid, verse: :desc
  context 'given a request with a sort parameter and a sorted response' do
    before { request_params['sort'] = 'id' }
    before { response.body = '[{"uid":3},{"uid":2},{"uid":1}]' }
    should_respond_with_expected_body sorts: [{name: 'id', by: :uid, verse: :desc}]
  end

  # e.g.: GET /?field=id + accepts_filter :value, by: :uid
  context 'given a request with a filter parameter and a filtered response' do
    before { request_params['field'] = 'id' }
    before { response.body = '[{"uid":3},{"uid":3},{"uid":3}]' }
    should_respond_with_expected_body filters: [{name: 'id', by: :uid}]
  end

  # TODO: Manage failing expectations
end