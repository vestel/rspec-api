require 'active_support'
require 'rack/utils'
require 'rspec-api/matchers'

module DSL
  module Request
    extend ActiveSupport::Concern

    module ClassMethods
      # Creates an example group for expectations on the response headers of
      # last API request and runs it to verify that it matches best practices:
      # * if request has entity body, the Content-Type header should be JSON
      # * if request has pages, the Link header should have a 'rel=prev' link
      def should_respond_with_expected_headers(options = {})
        context 'responds with headers that' do
          it { should_include_content_type :json }
          it { should_have_prev_page_link options[:page] }
        end
      end
    end

  private

    def should_include_content_type(type)
      expect(response).to include_content_type_if response_has_body?, type
    end

    def should_have_prev_page_link(page)
      expect(response).to have_prev_page_link_if request_is_paginated?(page)
    end

    def response_has_body?
      !Rack::Utils::STATUS_WITH_NO_ENTITY_BODY.include?(response.status)
    end

    def request_is_paginated?(page_parameter)
      request_params.key? page_parameter.to_s
    end
  end
end