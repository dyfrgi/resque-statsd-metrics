# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque/plugins/statsd_metrics/version'

Gem::Specification.new do |gem|
  gem.name          = "resque-statsd-metrics"
  gem.version       = Resque::Plugins::StatsdMetrics::VERSION
  gem.authors       = ["Michael Leuchtenburg"]
  gem.email         = ["michael@slashhome.org"]
  gem.description   = %q{A Resque plugin that sends job metrics (success, failure, queue, dequeue, run time) to statsd}
  gem.summary       = %q{Record Resque job metrics in statsd}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("resque", "~> 1.13")
  gem.add_dependency("statsd-ruby")
  gem.add_development_dependency("minitest", "~> 5.0.4")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("bundler")
  gem.add_development_dependency("mocha")
  gem.add_development_dependency("bourne")
end
