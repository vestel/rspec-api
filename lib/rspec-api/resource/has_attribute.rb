require 'active_support/core_ext/object/blank'
require 'rspec-api/resource/options'

module RSpecApi
  module Resource
    module HasAttribute
      def has_attribute(name, options, &block)
        if block_given?
          options[:type] = Hash[options[:type], {}] unless options[:type].is_a? Array
          nest_attributes options[:type], &Proc.new
        end
        if @attribute_ancestors.present?
          collection = @attribute_ancestors.last    # Hash and Array possible
          collection.each do |type, _|
            if collection.is_a? Array
              if type == :object
                index = collection.find_index(type)       # Update array
                collection[index] = {type => { name => options}}
              end
            else
              (collection[type] ||= {})[name] = options # Old behaviour (Hash provided)
            end
          end
        else
          (rspec_api_resource[:attributes] ||= {})[name] = options
        end
      end

    private

      def nest_attributes(hash, &block)
        (@attribute_ancestors ||= []).push hash
        yield
        @attribute_ancestors.pop
      end
    end
  end
end