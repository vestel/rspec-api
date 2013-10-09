module Http
  module Remote
    module Resource
      extend ActiveSupport::Concern

      module ClassMethods
        def authorize_with(options = {})
          rspec_api[:authorization] = options
        end
      end
    end
  end
end