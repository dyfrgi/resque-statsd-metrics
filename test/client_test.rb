require 'test_helper'

describe Resque::Plugins::StatsdMetrics::Client do
  after { restore_default_config }

  describe "#client" do
    subject { Resque::Plugins::StatsdMetrics::Client.client }

    it "must return a Statsd instance" do
      assert_kind_of ::Statsd, subject
    end

    describe "when not initialized with a host and port" do
      it "must use 'localhost' as the default hostname" do
        assert_equal "localhost", subject.host
      end

      it "must use 8125 as the default port" do
        assert_equal 8125, subject.port
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
        assert_equal @hostname, subject.host
      end

      it "must use the configured port" do
        assert_equal @port, subject.port
      end
    end

    describe "when initialized with a clientfactory" do
      before do
        @callcount = 0
        @returned = "notaclient"
        factory = lambda { @callcount += 1; @returned }
        Resque::Plugins::StatsdMetrics.configure do |config|
          config.clientfactory = factory
        end
        @client = subject
      end

      it "must call the factory " do
        assert_equal 1, @callcount
      end

      it "must return what the factory returns" do
        assert_equal @returned, @client
      end
    end
  end
end
