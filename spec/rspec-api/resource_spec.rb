require 'spec_helper'
require 'rspec-api/resource'

describe RSpecApi::Resource do
  methods = [:get, :put, :patch, :post, :delete, :adapter, :host, :throttle,
    :authorize_with, :has_attribute, :accepts]
  context 'example groups tagged as :rspec_api', :rspec_api do
    methods.each{|method| should_respond_to method}
  end

  context 'example groups that extend RSpecApi::Resource' do
    extend RSpecApi::Resource
    methods.each{|method| should_respond_to method}
  end

  resource :an_example_group_declared_with_resource do
    methods.each{|method| should_respond_to method}
  end

  context 'other example groups' do
    methods.each{|method| should_not_respond_to method}
  end
end