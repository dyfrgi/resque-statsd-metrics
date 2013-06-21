require 'test_helper'

describe Resque::Plugins::StatsdMetrics do
  before do
    @client = stub_everything
    Resque::Plugins::StatsdMetrics.configure do |c|
      c.clientfactory = -> { @client }
    end
  end

  describe "with a job that succeeds" do
    subject { WorkingJob }
    before { perform_job(subject) }

    it "reports to statsd when it succeeds" do
      assert_statsd_received(@client, :increment, "WorkingJob.success")
    end
  end

  describe "with a job that fails" do
    subject { BrokenJob }
    before { perform_job(subject) rescue nil }

    it "reports to statsd when it fails" do
      assert_statsd_received(@client, :increment, "BrokenJob.failure")
    end
  end
end
