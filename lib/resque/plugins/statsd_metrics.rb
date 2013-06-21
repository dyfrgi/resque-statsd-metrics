module Resque
  module Plugins
    module StatsdMetrics
      def after_perform_statsd(*args)
        Client.client.increment("#{prefix}.#{self}.success")
        Client.client.increment("#{prefix}.all.success")
      end

      def on_failure_statsd(exception, *args)
        Client.client.increment("#{prefix}.#{self}.failure")
        Client.client.increment("#{prefix}.all.failure")
      end

      def around_perform_statsd(*args)
        start = Time.now
        result = yield
        exec_time = ((Time.now - start) * 1000).round
        Client.client.timing("#{prefix}.#{self}.exec_time", exec_time)
        Client.client.timing("#{prefix}.all.exec_time", exec_time)
      end

      def after_enqueue_statsd(*args)
        Client.client.increment("#{prefix}.#{self}.enqueued")
        Client.client.increment("#{prefix}.all.enqueued")
      end

      private

      def prefix
        Resque::Plugins::StatsdMetrics.configuration.prefix
      end
    end
  end
end
