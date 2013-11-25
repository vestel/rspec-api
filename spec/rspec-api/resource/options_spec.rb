require 'spec_helper'
require 'active_support/core_ext/integer/time'
require 'rspec-api/resource/options'

describe RSpecApi::Resource::Options do
  extend RSpecApi::Resource::Options
  host 'http://example.com'
  adapter :rack, :some_rack_app
  throttle 2.seconds
  authorize_with token: 'foo'

  context 'sets the metadata :rspec_api_resource :host' do
    metadata_host = metadata[:rspec_api_resource][:host]
    it { expect(metadata_host).to eq 'http://example.com'}
  end

  context 'sets the metadata :rspec_api_resource :adapter' do
    metadata_adapter = metadata[:rspec_api_resource][:adapter]
    it { expect(metadata_adapter).to eq [:rack, :some_rack_app]}
  end

  context 'sets the metadata :rspec_api_resource :throttle' do
    metadata_throttle = metadata[:rspec_api_resource][:throttle]
    it { expect(metadata_throttle).to eq 2}
  end

  context 'sets the metadata :rspec_api_resource :authorize_with' do
    metadata_authorize_with = metadata[:rspec_api_resource][:authorize_with]
    it { expect(metadata_authorize_with).to eq token: 'foo'}
  end
end