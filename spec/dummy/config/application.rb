# Only use the TEST environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../boot', __FILE__)

# Load the Rails frameworks
require "active_record/railtie"
require "action_controller/railtie"

module Gigs
  class Application < Rails::Application
  end
end
