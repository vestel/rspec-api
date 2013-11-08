module RSpecApi
  module DSL
    module Fixtures # rename to Fixtures
      def existing(field)
        # To be overriden
      end

      def unknown(field)
        # To be overriden
      end

      def apply(method_name, options = {})
        options[:to].merge(apply: method_name, value: -> { options[:to][:value].call.send method_name })
      end

      def valid(options = {})
        # TODO: Here change the description
        options
      end

      def invalid(options = {})
        # TODO: Here change the description
        options
      end

      def create_fixture
        # To be overriden
      end

      def destroy_fixture
        # To be overriden
      end
    end
  end
end