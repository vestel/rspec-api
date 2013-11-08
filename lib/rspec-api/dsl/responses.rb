require 'rspec-api/expectations'

module RSpecApi
  module DSL
    module Responses
      include RSpecApi::Expectations::Resourceful

      def respond_with(*args, &block)
        if args.first.is_a?(Hash)
          more_status_expect = args.first
          more_headers_expect = {}
          more_body_expect = {}
        elsif args.first.is_a?(Array)
          more_status_expect, more_headers_expect, more_body_expect = args
        else
          more_status_expect = {status: args.first}
          more_headers_expect = {}
          more_body_expect = {}
        end

        all_expectations = @status_expect.merge(more_status_expect).merge(
        @headers_expect).merge(more_headers_expect).merge(@body_expect).
        merge(more_body_expect)

        expect_resourceful(@response, all_expectations)
        expect_custom(@response, @route_params, &block) if block_given?
      end

      def expect_custom(response, route_params, &block)
        context 'matches custom expectations' do
          # THE ONLY MISSING THING:
          it { instance_exec response, route_params, &block }
        end
      end
    end
  end
end