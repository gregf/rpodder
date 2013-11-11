# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rpodder/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'rpodder'
  gem.version       = Rpodder::VERSION
  gem.authors       = ['Greg Fitzgerald']
  gem.email         = ['greg@gregf.org']
  gem.description   = %q{Rpodder}
  gem.summary       = %q{Rpodder}
  gem.homepage      = 'https://github.com/gregf/rpodder'
  gem.licenses      = ['MIT']

  gem.files         = Dir['lib/**/*.rb'] + Dir['bin/*']
  gem.files        += Dir['[A-Z]*'] + Dir['spec/**/*']
  gem.files        += Dir['*\.gemspec']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'docopt'
  gem.add_dependency 'feedzirra'
  gem.add_dependency 'yell'
  gem.add_dependency 'sequel'
  gem.add_dependency 'sqlite3'
  gem.add_dependency 'iniparse'
  gem.add_dependency 'opml-reader'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rspec'
end
