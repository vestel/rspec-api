require_relative '../local_helper'

require 'rspec-api/http/local'
require 'active_support/core_ext/string' # camelize, constantize

module GigsRoute
  extend ActiveSupport::Concern

  module ClassMethods
    def setup_fixtures
      additional = rspec_api[:array] && (rspec_api[:sorts] || rspec_api[:filters])
      before_create_fixtures additional
      after_destroy_fixtures
    end

    def existing(field)
      model = rspec_api[:resource_name].to_s.camelize.constantize
      -> { model.pluck(field).first }
    end

    def unknown(field)
      model = rspec_api[:resource_name].to_s.camelize.constantize
      keys = possible_unknown_keys
      -> { keys.reject {|value| model.exists? field => value}.first }
    end

    def apply(method_name, options = {})
      -> { options[:to].call.send method_name }
    end

  private

    def before_create_fixtures(additional)
      model = rspec_api[:resource_name].to_s.camelize.constantize
      before(:all) do
        # TODO: Don't hard-code where, use the types
        instance = Concert.create! where: 'HeRe', year: 2010
        Concert.create! where: 'HeRe', year: 2000 if additional
        # instance.performers.create! name: 'Artist', website: 'http://www.example.com'
        # instance.performers.create! name: 'Artist2', website: 'http://example.com'
      end
    end

    def after_destroy_fixtures
      model = rspec_api[:resource_name].to_s.camelize.constantize
      after(:all) { model.destroy_all }
    end

    # TODO: Find a better way to explore possible unknown keys
    def possible_unknown_keys
      if RUBY_VERSION >= '2.0'
        0.downto(-Float::INFINITY).lazy
      else
        (-100..0)
      end
    end
  end
end

RSpec.configuration.include GigsRoute, rspec_api_dsl: :route