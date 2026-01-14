# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'iqvoc/skosxl/version'

Gem::Specification.new do |s|
  s.name        = 'iqvoc_skosxl'
  s.version     = Iqvoc::Skosxl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Robert Glaser', 'Till Schulte-Coerne', 'Frederik Dohr']
  s.email       = ['till.schulte-coerne@innoq.com']
  s.homepage    = 'http://iqvoc.net'
  s.summary     = 'iQvoc SKOS-XL extension'
  s.license     = 'Apache License 2.0'
  s.description = 'iQvoc - a SKOS(-XL) vocabulary management system built on the Semantic Web'

  s.add_dependency 'iqvoc', '~> 4.15.0'
  s.add_development_dependency 'bundler'

  s.files = %w(README.md Gemfile Gemfile.lock Rakefile iqvoc_skosxl.gemspec) +
            Dir.glob('{app,config,db,public,lib,test}/**/*')
  s.test_files = s.files.grep(%r{^test/})
  s.require_paths = ['lib']
end
