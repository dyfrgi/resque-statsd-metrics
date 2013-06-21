require 'test_helper'

describe Resque::Plugins::StatsdMetrics do
  after { restore_default_config }

  before do
    stub_statsd
  end

  it "uses any configured prefix" do
    @prefix = "prefixes.are.awesome"
    Resque::Plugins::StatsdMetrics.configure { |c| c.prefix = @prefix }
    perform_job(WorkingJob)
    assert_statsd_received(:increment, "#{@prefix}.WorkingJob.success")
  end

  describe "with a job that succeeds" do
    subject { WorkingJob }
    before { perform_job(subject) }

    it "reports to statsd when it succeeds" do
      assert_statsd_received(:increment, "resque.jobs.WorkingJob.success")
      assert_statsd_received(:increment, "resque.jobs.all.success")
    end
  end

  describe "with a job that fails" do
    subject { BrokenJob }
    before { perform_job(subject) rescue nil }

    it "reports to statsd when it fails" do
      assert_statsd_received(:increment, "resque.jobs.BrokenJob.failure")
      assert_statsd_received(:increment, "resque.jobs.all.failure")
    end
  end

  describe "with a job that takes some time" do
    subject { TimeTravelingJob }
    before { perform_job(subject) }

    it "reports the time taken to run perform" do
      assert_statsd_received(:timing, "resque.jobs.TimeTravelingJob.exec_time", 10000)
      assert_statsd_received(:timing, "resque.jobs.all.exec_time", 10000)
    end
  end
end
