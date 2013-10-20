# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../../../../Gemfile', __FILE__)
if File.exist?(gemfile)
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
end

# Optional: include rspec-api
# $:.unshift File.expand_path('../../../../lib', __FILE__)