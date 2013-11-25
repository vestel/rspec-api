require 'spec_helper'
require 'rspec-api/resource'

describe 'has_attribute' do
  extend RSpecApi::Resource
  has_attribute :id, type: :integer
  has_attribute :url, type: {string: :url}

  get '/' do
    attributes = metadata[:rspec_api_params][:attributes]
    it { expect(attributes).to eq id: {type: :integer}, url: {type: {string: :url}} }
  end
end

describe 'nested has_attribute' do
  extend RSpecApi::Resource
  has_attribute :members, type: :array do
    has_attribute :name, type: :string
    has_attribute :url, type: {string: :url}
  end

  get '/' do
    attributes = metadata[:rspec_api_params][:attributes]
    it { expect(attributes).to eq members: {type: {array: {name: {type: :string}, url: {type: {string: :url}}}}} }
  end
end