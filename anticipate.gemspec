# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "anticipate"

Gem::Specification.new do |s|
  s.name        = 'anticipate'
  s.version     = Anticipate::VERSION
  s.authors     = ['Josh Chisholm']
  s.description = 'Fluent interface for try-rescue-sleep-retry-abort'
  s.summary     = "anticipate-#{s.version}"
  s.email       = 'joshuachisholm@gmail.com'
  s.homepage    = 'http://github.com/joshski/anticipate'

  s.rubygems_version  = "1.3.7"
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {spec}/*`.split("\n")
  s.extra_rdoc_files  = ["README.rdoc"]
  s.require_path      = "lib"
end