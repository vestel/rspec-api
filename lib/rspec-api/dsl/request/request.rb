require 'active_support'

module DSL
  module Request
    extend ::ActiveSupport::Concern

    module ClassMethods
    end

    def request_params
      {} # To be overriden by more specific modules
    end
  end
end