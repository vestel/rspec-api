require 'active_support'
require 'rspec-api/matchers'

module DSL
  module Request
    extend ActiveSupport::Concern

    module ClassMethods
      # Creates an example group for expectations on the response body of the
      # last API request and runs it to verify that it matches best practices:
      # * if response is succesful and has a body
      #   -  the body should be a JSON-marshalled Array or Hash
      #   -  if request has a callback parameter, the body should be JSONP
      #   -  if request has a sort parameter, the body should be sorted
      #   -  if request has a filter parameter, the body should be filtered
      #   -  if custom expectations are passed, they should pass
      #   -  if some attributes are expected, the body should include them
      def should_respond_with_expected_body(options = {})
        context 'responds with a body that' do
          it { should_be_valid_json options[:type] }
          it { should_be_wrapped_by options[:callbacks] }
          it { should_be_sorted_by options[:sorts] }
          it { should_be_filtered_by options[:filters] }
          it { should_have_attributes options[:attributes] }
        end
      end
    end

    def should_be_valid_json(type)
      expect(response).to be_valid_json_if response_is_successful?, type
    end

    # If the request had a 'callback' query parameter, then the body should be
    # JSONP, otherwise it should not. For instance if the request was
    # `GET /?method=alert` and the request `accepts_callback :method`, then
    # the body must be a JSON wrapped in the alert(...) callback
    # The +callback+ param says how the request might have been made, e.g.
    # name: 'method', value: 'alert'... however to make sure that it was
    # really made, we need to check that request_params['method'] is present
    # and that is actually 'alert'
    def should_be_wrapped_by(callback_params_sets)
      callback_params = response_is_successful? && get_request_param_for_list(callback_params_sets)
      value = callback_params[:value] if callback_params
      expect(response).to be_a_jsonp_if callback_params, value
    end

    def should_be_sorted_by(sort_params_sets)
      sort_params = response_is_successful? && get_request_param_for_list(sort_params_sets)
      options = sort_params ? sort_params.slice(:by, :verse) : {}
      expect(response).to be_sorted_if sort_params, options
    end

    def should_be_filtered_by(filter_params_sets)
      # TODO: The following is just so the condition does not match if it's nil
      #       but this should be fixed in get_request_param_for_list
      if filter_params_sets
        filter_params_sets = filter_params_sets.dup
        filter_params_sets.each{|x| x[:value] = request_params.fetch(x[:name].to_s, :something_nil)}
      end
      filter_params = response_is_successful? && get_request_param_for_list(filter_params_sets)
      value = filter_params[:value] if filter_params
      options = filter_params ? filter_params.slice(:by, :comparing_with) : {}
      expect(response).to be_filtered_if filter_params, value, options
    end

    def should_have_attributes(attributes)
      expect(response).to have_attributes_if response_is_successful?, attributes
    end

    def get_request_param_for_list(params_sets)
      (params_sets || []).find do |params|
        conditions = []
        conditions << (request_params[params[:name].to_s] == params[:value])
        params.fetch(:extra_fields, {}).each do |name, value|
          conditions << (request_params[name.to_s] == value)
        end
        conditions.all?
      end
    end

    def response_is_successful?
      response.status < 400 && !Rack::Utils::STATUS_WITH_NO_ENTITY_BODY.include?(response.status)
    end
  end
end