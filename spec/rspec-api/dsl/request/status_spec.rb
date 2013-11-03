require 'spec_helper'
require 'ostruct'
require 'rspec-api/dsl/request/status'
RSpec.configuration.include DSL::Request # should have RSpecApi prefix ?!

describe 'should_respond_with_status' do
  let(:response) { OpenStruct.new status: 200 }
  should_respond_with_status :ok
  should_respond_with_status 200
  # TODO: Manage failing expectations
end