require 'spec_helper'
require 'active_support/core_ext/integer/time'
require 'rspec-api/resource/actions'

describe RSpecApi::Resource::Actions do
  extend RSpecApi::Resource::Actions
  extend RSpecApi::Resource::Options

  describe 'host' do
    host 'http://example.com'
    get '/' do
      request_host = metadata[:rspec_api_params][:host]
      it { expect(request_host).to eq 'http://example.com'}
    end
  end

  describe 'adapter' do
    adapter :rack, :some_rack_app
    get '/' do
      request_adapter = metadata[:rspec_api_params][:adapter]
      it { expect(request_adapter).to eq [:rack, :some_rack_app]}
    end
  end

  describe 'throttle' do
    throttle 2.seconds
    get '/' do
      request_throttle = metadata[:rspec_api_params][:throttle]
      it { expect(request_throttle).to eq 2}
    end
  end

  describe 'authorize_with' do
    authorize_with token: 'foo'
    get '/' do
      request_authorize_with = metadata[:rspec_api_params][:authorize_with]
      it { expect(request_authorize_with).to eq token: 'foo'}
    end
  end
end