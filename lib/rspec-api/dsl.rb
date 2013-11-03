require 'rspec-api/dsl/resource'
require 'rspec-api/dsl/route'
require 'rspec-api/dsl/request'

module DSL
end

# Just like RSpec Core’s `describe` method, `resource` generates a subclass of
# {ExampleGroup} and is available at the top-level namespace.
# The difference is that examples declared inside a `resource` block have access
# to RSpec API own methods, defined in DSL::Resource, such as `has_attribute`,
# `accepts_filter`, `get`, `post`, and so on.
def resource(name, args = {}, &block)
  args.merge! rspec_api_dsl: :resource, rspec_api: {resource_name: name}
  describe name, args, &block
end

RSpec.configuration.include DSL::Resource, rspec_api_dsl: :resource
RSpec.configuration.include DSL::Route, rspec_api_dsl: :route
RSpec.configuration.include DSL::Request, rspec_api_dsl: :request

if RSpec::Core::Version::STRING >= '2.14'
  RSpec.configuration.backtrace_exclusion_patterns << %r{lib/rspec-api/dsl\.rb}
end