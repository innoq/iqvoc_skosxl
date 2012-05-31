# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "iqvoc/skosxl/version"

Gem::Specification.new do |s|
  s.name        = "iqvoc_skosxl"
  s.version     = Iqvoc::SKOSXL::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Robert Glaser", "Till Schulte-Coerne", "Frederik Dohr"]
  s.email       = ["till.schulte-coerne@innoq.com"]
  s.homepage    = "http://innoq.com"
  s.summary     = "iQvoc SKOS-XL extension"
  s.description = ""

  s.add_dependency "iqvoc", "~> 4.0.0"
  s.add_dependency "bundler"

  s.files = %w(README.md Gemfile Gemfile.lock Rakefile iqvoc_skosxl.gemspec) + Dir.glob("{app,config,db,public,lib,test}/**/*")
  s.test_files = Dir.glob("{test}/**/*")
  s.executables = Dir.glob("{bin}/**/*")
  s.require_paths = ["lib"]
end
