module RSpecApi
  module DSL
    module Accepts

      def accepts_page(page_parameter)
        any_page = 2
        @expectations << {
          query_params: {}.tap{|qp| qp[page_parameter] = any_page},
          status_expect: {status: 200},
          headers_expect: {has_prev_page: true}
        }
      end

      def accepts_sort(sort_parameter, options={})
        @expectations << {
          query_params: {sort: sort_parameter}.merge(options.fetch(:sort_if, {})),
          before: create_fixture,
          after: destroy_fixture,
          status_expect: {status: 200},
          body_expect: {sort: options.slice(:by, :verse)}
        }
      end

      def accepts_callback(callback_parameter)
        any_callback = 'a_callback'
        @expectations << {
          query_params: {}.tap{|qp| qp[callback_parameter] = any_callback},
          status_expect: {status: 200},
          body_expect: {callback: any_callback}
        }
      end

      def accepts_filter(filter_parameter, options={})
        value = existing(options[:by])
        @expectations << {
          query_params: {}.tap{|qp| qp[filter_parameter] = value},
          before: create_fixture,
          after: destroy_fixture,
          status_expect: {status: 200},
          body_expect: {filter: options.slice(:by, :comparing_with).merge(value: value)}
        }
      end
    end
  end
end

