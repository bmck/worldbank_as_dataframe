# -*- encoding: utf-8 -*-
require File.expand_path('../lib/worldbank_as_dataframe/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'worldbank_as_dataframe'
  gem.version     = WorldbankAsDataframe::VERSION
  gem.authors     = ['Bill McKinnon']
  gem.email       = ['bill.mckinnon@bmck.org']
  gem.homepage    = 'https://github.com/bmck/worldbank_as_dataframe'
  gem.summary     = %q{A Ruby wrapper around the World Bank's Development Indicators API}
  gem.description = %q{A Ruby wrapper around the World Bank's Development Indicators API, with credit to Code for America and Justin Stoller}

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.require_paths = ['lib']

  gem.add_development_dependency 'ZenTest', '~> 4.5'
  gem.add_development_dependency 'maruku', '~> 0.6'
  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.add_development_dependency 'yard', '~> 0.7'
  gem.add_development_dependency 'webmock', '~> 1.8.9'  

  gem.add_runtime_dependency 'httparty'
  gem.add_runtime_dependency 'polars-df'
  gem.add_runtime_dependency 'multi_json'
  # gem.add_runtime_dependency 'rash', '~> 0.3.0'  
end
