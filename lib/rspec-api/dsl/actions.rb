require 'rspec-api/dsl/requests'

module RSpecApi
  module DSL
    module Actions
      include RSpecApi::DSL::Fixtures
      include RSpecApi::DSL::Requests

      def self.define_action(action)
        define_method action do |route, options = {}, &block|
          expectations = @expectations
          attributes = @attributes
          authorization = @authorization
          resource = @resource
          collection = options[:collection]
          describe "#{action.upcase} #{route}" do
            @action = action
            @route = route
            @expectations = expectations
            @attributes = attributes
            @authorization = authorization
            @collection = collection
            @resource = resource
            instance_eval &block
          end
        end
      end

      define_action :get
      define_action :put
      define_action :patch
      define_action :post
      define_action :delete
    end
  end
end
