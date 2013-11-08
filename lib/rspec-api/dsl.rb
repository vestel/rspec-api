require 'rspec-api/dsl/accepts'
require 'rspec-api/dsl/actions'
require 'rspec-api/dsl/attributes'

module RSpecApi
  module DSL
    include Accepts
    include Actions
    include Attributes
    include Fixtures
  end
end

# RSpecApi provides methods to test RESTful APIs.
#
# To have these methods available in your RSpec ExampleGroups you have to
# tag the `describe` block with the `:rspec_api` metadata.
#
#  describe "Artists", rspec_api: true do
#     ... # here you can use `get`, `delete`, etc.
#  end
RSpec.configuration.extend RSpecApi::DSL, rspec_api: true

# Alternatively, you replace `describe` with `resource`, for the same result:
#
#
#  resource :artist do
#     ... # same as before, here you can use `get`, `delete`, etc.
#  end
#
#
# `resource` is indeed the only top-level namespace RSpecApi method.
def resource(name, args = {}, &block)
  args.merge! rspec_api: true
  resources = (@resources ||= [])
  resource = describe name.to_s.pluralize.humanize, args do
    @resource = name
    @resources = resources
    @expectations = []
    @expectations << {query_params: {}, status_expect: {status: 200}, body_expect: {attributes: {name: {type: :string}, website: {type: [:null, string: :url]}}}}
    @attributes = {}
    instance_exec &block
  end
  @resources << resource
end