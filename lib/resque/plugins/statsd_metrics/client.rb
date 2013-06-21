require 'statsd'

module Resque
  module Plugins
    module StatsdMetrics
      module Client
        def self.client
          if StatsdMetrics.configuration.clientfactory.respond_to? :call
            StatsdMetrics.configuration.clientfactory.call
          else
            ::Statsd.new StatsdMetrics.configuration.hostname, StatsdMetrics.configuration.port
          end
        end
      end
    end
  end
end
