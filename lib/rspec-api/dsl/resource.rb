require 'active_support'
module DSL
  module Resource
    extend ::ActiveSupport::Concern

    module ClassMethods
      def rspec_api
        metadata[:rspec_api]
      end

      def self.define_action(verb)
        define_method verb do |route, args = {}, &block|
          rspec_api.merge! array: args.delete(:array), verb: verb, route: route
          args.merge! rspec_api_dsl: :route
          describe("#{verb.upcase} #{route}", args, &block)
        end
      end

      define_action :get
      define_action :put
      define_action :patch
      define_action :post
      define_action :delete


      def has_attribute(name, options = {}, &block)
        if block_given?
          # options[:type] can be symbol, hash or array
          # but if you have a block we must make it a hash
          options[:type] = Hash[*Array.wrap(options[:type]).map{|x| x.is_a?(Hash) ? [x.keys.first, x.values.first] : [x, {}]}.flatten] unless options[:type].is_a? Hash
          # we only set the block as the new format of Object and Array
          nest_attributes(options[:type], &Proc.new)
        end
        if @attribute_ancestors.present?
          hash = @attribute_ancestors.last
          hash.slice(:object, :array).each do |type, _|
            (hash[type] ||= {})[name] = options
          end
        else
          hash = (rspec_api[:attributes] ||= {})
          hash[name] = options
        end
      end

      def nest_attributes(hash, &block)
        (@attribute_ancestors ||= []).push hash
        yield
        @attribute_ancestors.pop
      end

      def accepts_page(page_parameter)
        rspec_api[:page] = {name: page_parameter, value: 2}
      end

      def accepts_sort(sort_parameter, options={})
        (rspec_api[:sorts] ||= []) << options.merge(name: 'sort', value: sort_parameter)
      end

      def accepts_filter(filter_parameter, options={})
        (rspec_api[:filters] ||= []) << options.merge(name: filter_parameter)
      end

      def accepts_callback(callback_parameter)
        (rspec_api[:callbacks] ||= []) << {name: callback_parameter.to_s, value: 'a_callback'}
      end
    end
  end
end