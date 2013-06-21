require 'test_helper'

describe Resque::Plugins::StatsdMetrics::Configuration do
  after { restore_default_config }

  subject { Resque::Plugins::StatsdMetrics.configuration }

  describe "when not initialized with a host and port" do
    it "must use 'localhost' as the default hostname" do
      assert_equal "localhost", subject.hostname
    end

    it "must use 8125 as the default port" do
      assert_equal 8125, subject.port
    end

    it "must not define a clientfactory by default" do
      assert_nil subject.clientfactory
    end
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
