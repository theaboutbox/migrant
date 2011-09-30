# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "migrant/version"

Gem::Specification.new do |s|
  s.name        = "migrant"
  s.version     = Migrant::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Cameron Pope"]
  s.email       = ["cameron@theaboutbox.com"]
  s.homepage    = ""
  s.summary     = %q{Take your Vagrant to the Cloud}
  s.description = %q{A simple an opinionated way to replicate a Vagrant setup on EC2 or Rackspace}

  s.rubyforge_project = "migrant"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = 'migrant'
  s.require_paths = ["lib"]

  s.add_dependency 'thor'
  s.add_dependency 'fog'
  s.add_development_dependency 'rspec'
end
