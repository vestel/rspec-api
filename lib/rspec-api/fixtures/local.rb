module RSpecApi
  module DSL
    module Fixtures # rename to Fixtures
      def existing(field)
        {field: field, proc: :existing, value: existing_value_for(field)}
      end

      def unknown(field)
        {field: field, proc: :unknown, value: missing_value_for(field)}
      end

      def apply(method_name, options = {})
        options[:to].merge(apply: method_name, value: -> { options[:to][:value].call.send method_name })
      end

      def valid(options = {})
        # TODO: Here change the description
        options
      end

      def invalid(options = {})
        # TODO: Here change the description
        options
      end

      def create_fixture
        # TODO: Random values from attributes
        -> {
          model = @resource.to_s.classify.constantize
          case @resource
          when :artist then model.create! name: 'Madonna', website: 'http://www.example.com'
          when :concert then model.create! where: 'Coachella', year: 2010
          end
        }
      end

      def destroy_fixture
        -> {@resource.to_s.classify.constantize.destroy_all}
      end

      def existing_value_for(field)
        -> {@resource.to_s.classify.constantize.pluck(field).first}
      end
      
      def missing_value_for(field)
        -> {-1}
      end
    end
  end
end