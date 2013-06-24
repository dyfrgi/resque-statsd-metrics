require 'resque-statsd-metrics'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/setup'
require 'bourne'
require 'resque'
require 'timecop'
require 'mock_redis'

Resque.redis = MockRedis.new

def restore_default_config
  Resque::Plugins::StatsdMetrics.instance_variable_set(:@configuration, nil)
end

def perform_job(klass, *args)
  resque_job = Resque::Job.new(:testqueue, 'class' => klass, 'args' => args)
  resque_job.perform
end

def assert_statsd_received(method, *args)
  assert_received(@client, method) { |e| e.with(*args) }
end

def stub_statsd
  @client ||= stub_everything
  Resque::Plugins::StatsdMetrics.configure do |c|
    c.clientfactory = -> { @client }
  end
end

class TestJob
  extend Resque::Plugins::StatsdMetrics

  def self.queue
    :testqueue
  end

  def self.perform(*args)
    true
  end
end

class WorkingJob < TestJob; end

class BrokenJob < TestJob
  extend Resque::Plugins::StatsdMetrics

  def self.perform(*args)
    raise "b0rked"
  end
end

class TimeTravelingJob < TestJob
  extend Resque::Plugins::StatsdMetrics

  def self.before_perform_aaaaa
    Timecop.freeze
  end

  def self.perform
    Timecop.freeze(Time.now + 10)
    true
  end

  def self.after_perform_aaaaa
    Timecop.return
  end
end
