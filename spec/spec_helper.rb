require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.order = 'random'
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run_excluding failing: true
  config.filter_run_excluding wip: true
  config.filter_run_including only: true
  config.run_all_when_everything_filtered = true
end