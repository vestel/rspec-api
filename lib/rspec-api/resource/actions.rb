require 'rspec-api/requests'
require 'rspec-api/resource/options'

module RSpecApi
  module Resource
    module Actions
      [:get, :put, :patch, :post, :delete].each do |action|
        define_method action do |route, rspec_api_options = {}, &block|
          options = rspec_api_options.merge route: route, action: action
          options = rspec_api_resource.merge options
          describe description_for(options), rspec_api_params: options do
            extend RSpecApi::Requests
            instance_eval &block if block
          end
        end
      end

    private

      def description_for(params = {})
        action, name, plural = params.values_at(:action, :resource_name, :collection)
        [verb_for(action), object_for(name.to_s, plural)].compact.join ' '
      end

      def verb_for(action)
        case action
          when :get then 'Getting'
          when :put then 'Editing'
          when :patch then 'Editing'
          when :post then 'Creating'
          when :delete then 'Deleting'
        end
      end

      def object_for(name, plural)
        plural ? "a list of #{name.pluralize}" : "one #{name}"
      end
    end
  end
end