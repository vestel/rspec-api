module Http
  module Remote
    module Request
      extend ActiveSupport::Concern

      def response
        @last_response
      end

      def request_params
        @last_request.params
      end
    end
  end
end