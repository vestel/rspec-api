require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.order = 'random'
  config.filter_run_excluding failing: true
  config.filter_run_excluding wip: true
  config.filter_run_including only: true
  config.run_all_when_everything_filtered = true
end