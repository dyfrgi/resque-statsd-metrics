require 'resque-statsd-metrics'
require 'minitest/autorun'
require 'minitest/pride'

def restore_default_config
  Resque::Plugins::StatsdMetrics.configuration = nil
end
