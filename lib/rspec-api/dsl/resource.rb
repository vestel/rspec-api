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

      def has_attribute(name, type, options = {})
        parent = (@attribute_ancestors || []).inject(rspec_api) {|chain, step| chain[:attributes][step]}
        (parent[:attributes] ||= {})[name] = options.merge(type: type)
        nested_attribute(name, &Proc.new) if block_given?
      end

      def accepts_page(page_parameter)
        rspec_api[:page] = {name: page_parameter, value: 2}
      end

      def accepts_sort(sort_parameter, options={})
        rspec_api[:sort] = {name: sort_parameter, attribute: options[:on]}
      end

      # TODO: the second 'accepts_filter' should not override the first, but add
      def accepts_filter(filter_parameter, options={})
        rspec_api[:filter] = options.merge(name: filter_parameter)
      end

      def accepts_callback(callback_parameter)
        rspec_api[:callback] = {name: callback_parameter, value: 'a_callback'}
      end

    private

      def nested_attribute(name)
        (@attribute_ancestors ||= []).push name
        yield
        @attribute_ancestors.pop
      end
    end
  end
end
