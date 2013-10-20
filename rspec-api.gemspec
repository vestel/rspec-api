lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec-api/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-api"
  spec.version       = RspecApi::VERSION
  spec.authors       = ["claudiob"]
  spec.email         = ["claudiob@gmail.com"]
  spec.description   = %q{When you write a web API, you make a promise to the world.
  RSpec API helps you keep your promise.}
  spec.summary       = %q{Methods to write more compact and meaningful,
    auto-documented specs for web APIs.}
  spec.homepage      = 'https://github.com/rspec-api/rspec-api'
  spec.license       = 'MIT'

  spec.files         = Dir['{lib}/**/*'] + ['MIT-LICENSE', 'README.md']

  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.0'
  spec.required_rubygems_version = ">= 1.3.6"

  spec.add_dependency 'rspec'
  spec.add_dependency 'rack' # for ::Utils
  spec.add_dependency 'activesupport' # for ::Concern

  # For local
  spec.add_dependency 'rack-test'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'kaminari' # add pagination to models/controllers
  spec.add_development_dependency 'api-pagination' # add pagination Link headers to API
  spec.add_development_dependency 'jbuilder' # views

  # For remote
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'faraday-http-cache', '>= 0.3.0'
end