module Http
  module Local
    module Route
      extend ActiveSupport::Concern

      def send_request(verb, route, body)
        header 'Accept', 'application/json'
        send verb, route, body
      end
    end
  end
end