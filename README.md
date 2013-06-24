# Resque::Statsd::Metrics

This A Resque plugin that sends job metrics (success, failure, queue, run time) to statsd

## Installation

Add this line to your application's Gemfile:

    gem 'resque-statsd-metrics'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-statsd-metrics

## Usage

In your Resque job class, include this line:

    extend Resque::Statsd::Metrics

## Configuration

### Where to connect to Statsd

You'll need to tell the library where to find Statsd or it will use the one on
localhost. You can do this in two different ways.

Set the hostname and port:
    Resque::Plugins::StatsdMetrics.configure do |c|
        c.hostname = "mystatsdserver.example.com"
        c.port = 8125
    end

Provide a factory which will return a Statsd instance:
    Resque::Plugins::StatsdMetrics.configure do |c|
        c.clientfactory = -> { MyStatsdFactory.client }
    end

### Prefix to use

By default, resque.jobs will be the namespace all stats are reported to. If
you'd prefer them to be reported somewhere else, you can change the prefix.
This does not change the prefix used by the Statsd instance, in case you're
sharing objects between this class and other users of Statsd.

    Resque::Plugins::StatsdMetrics.configure do |c|
        c.prefix = "i.love.background.processing"
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
