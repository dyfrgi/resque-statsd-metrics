require 'test_helper'

describe Resque::Plugins::StatsdMetrics do
  after { restore_default_config }

  before do
    @client = stub_everything
    Resque::Plugins::StatsdMetrics.configure do |c|
      c.clientfactory = -> { @client }
    end
  end

  it "uses any configured prefix" do
    @prefix = "prefixes.are.awesome"
    Resque::Plugins::StatsdMetrics.configure { |c| c.prefix = @prefix }
    perform_job(WorkingJob)
    assert_statsd_received(@client, :increment, "#{@prefix}.WorkingJob.success")
  end

  describe "with a job that succeeds" do
    subject { WorkingJob }
    before { perform_job(subject) }

    it "reports to statsd when it succeeds" do
      assert_statsd_received(@client, :increment, "resque.jobs.WorkingJob.success")
      assert_statsd_received(@client, :increment, "resque.jobs.total.success")
    end
  end

  describe "with a job that fails" do
    subject { BrokenJob }
    before { perform_job(subject) rescue nil }

    it "reports to statsd when it fails" do
      assert_statsd_received(@client, :increment, "resque.jobs.BrokenJob.failure")
      assert_statsd_received(@client, :increment, "resque.jobs.total.failure")
    end
  end
end
