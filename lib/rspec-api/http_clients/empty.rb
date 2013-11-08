module RSpecApi
  module DSL
    module HttpClient
      def send_request(verb, route, body, authorization)
        # To be overriden
      end

      def last_response
        # To be overriden. status MUST be a number, headers MUST be a hash
        OpenStruct.new status: nil, headers: {} # body: nil,
      end
    end
  end
end