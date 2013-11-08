module RSpecApi
  module DSL
    module Attributes
      def has_attribute(name, options = {}, &block)
        @attributes[name] = options
      end

      def attributes_of(resource)
        @resources.find{|r| r.description == resource.to_s.pluralize.humanize}.instance_variable_get '@attributes'
      end
    end
  end
end