module Resque
  module Plugins
    module StatsdMetrics
      def after_perform_statsd(*args)
        Client.client.increment("#{self}.success")
      end

      def on_failure_statsd(*args)
        Client.client.increment("#{self}.failure")
      end
    end
  end
end
