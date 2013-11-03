require 'active_support'
require 'rspec-api/matchers'

module DSL
  module Request
    extend ::ActiveSupport::Concern

    module ClassMethods
      # Creates an example group for expectations on the HTTP status code of the
      # last API request and runs it to verify that it matches +status+.
      def should_respond_with_status(status)
        context 'responds with a status code that' do
          it { expect(response).to have_status status }
        end
      end
    end
  end
end