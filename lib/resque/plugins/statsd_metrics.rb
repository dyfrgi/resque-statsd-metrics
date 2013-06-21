module Resque
  module Plugins
    module StatsdMetrics
      def after_perform_statsd(*args)
        Client.client.increment("#{prefix}.#{self}.success")
        Client.client.increment("#{prefix}.total.success")
      end

      def on_failure_statsd(*args)
        Client.client.increment("#{prefix}.#{self}.failure")
        Client.client.increment("#{prefix}.total.failure")
      end

      private

      def prefix
        Resque::Plugins::StatsdMetrics.configuration.prefix
      end
    end
  end
end
