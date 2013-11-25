module RSpecApi
  module Resource
    module Options
      def adapter(*args)
        rspec_api_resource[:adapter] = args
      end

      def host(host)
        rspec_api_resource[:host] = host
      end

      def throttle(seconds_to_sleep)
        rspec_api_resource[:throttle] = seconds_to_sleep
      end

      def authorize_with(auth_params = {})
        rspec_api_resource[:authorize_with] = auth_params
      end

    private

      def rspec_api_resource
        (metadata[:rspec_api_resource] ||= {})
      end
    end
  end
end