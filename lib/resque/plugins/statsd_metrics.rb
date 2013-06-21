module Resque
  module Plugins
    module StatsdMetrics
      def after_perform_statsd(*args)
        increment("success")
      end

      def on_failure_statsd(exception, *args)
        increment("failure")
      end

      def around_perform_statsd(*args)
        start = Time.now
        result = yield
        exec_time = ((Time.now - start) * 1000).round
        client.timing("#{prefix}.#{self}.exec_time", exec_time)
        client.timing("#{prefix}.all.exec_time", exec_time)
      end

      def after_enqueue_statsd(*args)
        increment("enqueued")
      end

      private

      def timing(key, time)
        client.timing("#{prefix}.#{self}.%{key}", time)
        client.timing("#{prefix}.all.%{key}", time)
      end

      def increment(key)
        client.increment("#{prefix}.#{self}.#{key}")
        client.increment("#{prefix}.all.#{key}")
      end

      def client
        Client.client
      end

      def prefix
        Resque::Plugins::StatsdMetrics.configuration.prefix
      end
    end
  end
end
