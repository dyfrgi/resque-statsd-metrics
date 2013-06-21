require 'test_helper'

describe Resque::Plugins::StatsdMetrics::Configuration do
  after { restore_default_config }

  subject { Resque::Plugins::StatsdMetrics.configuration }

  describe "when not configured" do
    it "must use 'localhost' as the default hostname" do
      assert_equal "localhost", subject.hostname
    end

    it "must use 8125 as the default port" do
      assert_equal 8125, subject.port
    end

    it "must not define a clientfactory by default" do
      assert_nil subject.clientfactory
    end

    it "must use 'resque.jobs' as a prefix" do
      assert_equal "resque.jobs", subject.prefix
    end
  end

  it "must allow configuring the prefix" do
    Resque::Plugins::StatsdMetrics.configure { |c| c.prefix = "some.crazy.prefix" }
    assert_equal "some.crazy.prefix", subject.prefix
  end

  describe "when initialized with a host and port" do
    before do
      @hostname = "bogustesthostname.example"
      @port = 1234

      Resque::Plugins::StatsdMetrics.configure do |config|
        config.hostname = @hostname
        config.port = @port
      end
    end

    it "must use the configured hostname" do
      assert_equal @hostname, subject.hostname
    end

    it "must use the configured port" do
      assert_equal @port, subject.port
    end
  end
end
