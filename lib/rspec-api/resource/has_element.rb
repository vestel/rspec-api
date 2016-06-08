require 'active_support/core_ext/object/blank'
require 'rspec-api/resource/options'

module RSpecApi
  module Resource
    module HasElement
      def has_element(options)
        if @attribute_ancestors.present?
          collection = @attribute_ancestors.last    # Hash and Array possible
          collection.each do |type, _|
            (collection[type] ||= {})['.*'] = options # Old behaviour (Hash provided)
          end
        else
          (rspec_api_resource[:attributes] ||= {})['.*'] = options
        end
      end

    end
  end
end