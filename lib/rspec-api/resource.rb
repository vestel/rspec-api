require 'rspec/core'
require 'active_support/inflector'
require 'rspec-api/resource/actions'
require 'rspec-api/resource/options'
require 'rspec-api/resource/has_attribute'
require 'rspec-api/resource/has_element'
require 'rspec-api/resource/accepts'

module RSpecApi
  # Provides actions and expectations method to RSpec Example groups, useful to
  # describe the endpoints and expectations of a web API resource.
  #
  # To have these matchers available inside of an RSpec `describe` block,
  # include that block inside a block with the `:rspec_api` metadata, or
  # explicitly include the RSpecApi::Resource module.
  #
  # @example Tag a `describe` block as `:rspec_api`:
  #   describe "Artists", rspec_api: true do
  #     ... # here you can write `get`, `has_attribute`, `host`, etc.
  #   end
  #
  # @example Explicitly include the RSpecApi::Resource module
  #   describe "Artists" do
  #     include RSpecApi::Resource
  #     ... # here you can write `get`, `has_attribute`, `host`, etc.
  #   end
  module Resource
    include Actions
    include Options
    include HasAttribute
    include HasElement
    include Accepts
  end
end
RSpec.configuration.extend RSpecApi::Resource, rspec_api: true

# You can also have the methods available in a RSpec Example group using
# `resource`. This is the only method that RSpecApi adds to the top-level
# namespace and it's equivalent to a `describe` block with RSpecApi::Resource:
#
# @example Describe the resource artist:
#
#  resource :artist do
#     ... # here you can write `get`, `has_attribute`, `host`, etc.
#  end
def resource(name, args = {}, &block)
  describe name.to_s.pluralize.humanize, args do
    extend RSpecApi::Resource
    rspec_api_resource[:resource_name] = name
    instance_exec &block
  end
end