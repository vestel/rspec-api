# faraday-http-cache is a great gem that correctly ignores Private Cache
# For the sake of saving Github calls, let's cache Private as well!

require 'faraday-http-cache'

module Faraday
  class HttpCache
    class CacheControl
      def private?
        false
      end
    end
  end
end
