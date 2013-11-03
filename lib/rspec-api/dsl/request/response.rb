require 'active_support'

module DSL
  module Request
    extend ::ActiveSupport::Concern

    module ClassMethods
      # Runs a set of expectations on the result of the last API request.
      # The most basic way to call `respond_with` is with a status code:
      #
      #     respond_with :ok
      #
      # This simple line will run a number of expectations, based on best
      # practices that any RESTful API is expected to match:
      # * the returned HTTP status will be matched against 200 OK
      # * the response headers will be checked for Content-Type etc.
      # * the respone body will be checked for attributes etc.
      #
      # Additionally, the user can specify custom expectations for the
      # response by passing a block to the method:
      #
      #    respond_with :ok do |response|
      #      expect(response).to be_successful?
      #    end
      #
      # In this case, after all the *implicit* expectations are run, the
      # JSON-parsed response body is passed to the block to make sure that
      # (in the example above), the body is a hash with a 'color' key and
      # the 'green' value
      def respond_with(status_symbol, &block)
        should_respond_with_status status_symbol
        should_respond_with_expected_headers headers_options
        should_respond_with_expected_body body_options
        should_match_custom_response_expectations &block if block_given?
      end

    private

      def headers_options
        {page: rspec_api.fetch(:page, {})[:name].to_s}
      end

      def body_options
        {
          type: rspec_api[:array] ? Array : Hash,
          callbacks: rspec_api.fetch(:callbacks, []),
          sorts: rspec_api.fetch(:sorts, []),
          filters: rspec_api.fetch(:filters, []),
          attributes: rspec_api.fetch(:attributes, {})
        }
      end

      def should_match_custom_response_expectations(&block)
        it { instance_exec response, @url_params, &block }
      end
    end

    def response
      # To be overriden by more specific modules
      OpenStruct.new # body: nil, status: nil, headers: {}
    end

    def response_body
      JSON response_body_without_callbacks
    rescue JSON::ParserError, JSON::GeneratorError
      nil
    end

    def response_headers
      response.headers || {}
    end

    def response_status
      response.status
    end

  private

    def response_body_without_callbacks
      body = response.body
      # TODO: extract the 'a_callback' constant
      callback_pattern = %r[a_callback\((.*?)\)]
      body =~ callback_pattern ? body.match(callback_pattern)[1] : body
    end
  end
end