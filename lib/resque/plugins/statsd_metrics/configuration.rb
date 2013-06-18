module Resque
  module Plugins
    module StatsdMetrics
      class Configuration
        attr_accessor \
          :hostname,
          :port,
          :clientfactory

        def initialize
          @hostname = "localhost"
          @port = 8125
        end

      end

      class << self
        attr_accessor :configuration

        def configuration
          @configuration ||= Configuration.new
        end
      end

      def self.configure
        self.configuration ||= Configuration.new
        yield configuration
      end
    end
  end
end
