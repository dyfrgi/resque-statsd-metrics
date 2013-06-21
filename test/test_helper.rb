require 'resque-statsd-metrics'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/setup'
require 'bourne'
require 'resque'
require 'timecop'

def restore_default_config
  Resque::Plugins::StatsdMetrics.configuration = nil
end

def perform_job(klass, *args)
  resque_job = Resque::Job.new(:testqueue, 'class' => klass, 'args' => args)
  resque_job.perform
end

def assert_statsd_received(client, method, *args)
  assert_received(client, method) { |e| e.with(*args) }
end

class WorkingJob
  extend Resque::Plugins::StatsdMetrics

  def self.perform(*args)
    true
  end
end

class BrokenJob
  extend Resque::Plugins::StatsdMetrics

  def self.perform(*args)
    raise "b0rked"
  end
end

class TimeTravelingJob
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
