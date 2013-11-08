require 'rspec-api/dsl/responses'

module RSpecApi
  module DSL
    module Requests
      def my_collection_request(query_params = {}, &block)
        @expectations.each do |options|
          single_request(options.deep_merge(body_expect: {collection: true}, query_params: query_params), &block)
        end
      end

      def respond_with(*args) # NOT THE TRUE ONE
        request_with do
          respond_with(*args)
        end
      end

      def request_with(query_params = {}, &block)
        if @collection
          my_collection_request(query_params, &block)
        else
          single_request(query_params: query_params, &block)
        end
      end

      def single_request(options = {}, &block)
        query_params = options.fetch(:query_params, {})
        status_expect = options.fetch(:status_expect, {status: 200})
        headers_expect = options.fetch(:headers_expect, {type: :json})
        body_expect = options.fetch(:body_expect, {collection: false}) # Or maybe nothing
        body_expect = body_expect.merge(attributes: @attributes) if @attributes
        before_fun = options.fetch(:before, -> {})
        after_fun = options.fetch(:after, -> {})
        query = {authorization: @authorization, route_params: {}, action: @action, route: @route, query_params: query_params, status_expect: status_expect, headers_expect: headers_expect, body_expect: body_expect, before: before_fun, after: after_fun}

        query_params.each do |k, v|
          if v.is_a?(Hash) && v[:proc] && v[:value] # so we avoid getting the hash of the callback called :proc
            query[:query_params][k] = v[:value]
            if v[:proc] == :existing
              query = query.merge before: create_fixture, after: destroy_fixture
            end
          end
        end

        my_real_request(query, &block)
      end

      def my_real_request(query = {}, &block)
        query[:before].call

        query.fetch(:query_params, {}).each do |k, v|
          query[:query_params][k] = v.is_a?(Proc) ? v.call : v
          if query[:route].match "/:#{k}"
            query[:route] = query[:route].gsub "/:#{k}", "/#{query[:query_params][k]}"
            query[:route_params][k] = query[:query_params].delete k
          end
        end

        describe "with #{query[:route].is_a?(Proc) ? query[:route].call : query[:route]}#{" and #{query[:query_params]}" if query[:query_params].any?}" do
          extend RSpecApi::DSL::Responses
          extend RSpecApi::DSL::HttpClient
          send_request query[:action], (query[:route].is_a?(Proc) ? query[:route].call : query[:route]), query[:query_params], query[:authorization]
          @response = last_response
          @status_expect = query.fetch :status_expect, {}
          @headers_expect = query.fetch :headers_expect, {}
          @body_expect = query.fetch :body_expect, {}
          @route_params = query.fetch :route_params, {}
          if @body_expect.fetch(:filter, {})[:value].is_a?(Hash) && @body_expect.fetch(:filter, {})[:value][:proc]
            @body_expect[:filter][:value] = @body_expect[:filter][:value][:value].call
          end
          instance_exec &block
        end

        query[:after].call
      end
    end
  end
end