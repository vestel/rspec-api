require 'rspec-api'

require File.expand_path("../../../dummy/config/environment.rb",  __FILE__)
def app
  Rails.application
end

# Use unknown for invalid values
def unknown(field)
  -1
end
