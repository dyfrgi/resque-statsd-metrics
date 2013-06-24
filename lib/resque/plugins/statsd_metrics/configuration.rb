module Resque
  module Plugins
    module StatsdMetrics
      class Configuration
        attr_accessor \
          :hostname,
          :port,
          :clientfactory,
          :prefix

        def initialize
          @hostname = "localhost"
          @port = 8125
          @prefix = "resque.jobs"
        end

      end

      class << self
        def configuration
          @configuration ||= Configuration.new
        end

        def configure
          yield configuration
        end
      end
    end
  end
end
