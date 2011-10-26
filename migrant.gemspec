# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "migrant/version"

Gem::Specification.new do |s|
  s.name        = "migrant-boxes"
  s.version     = Migrant::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Cameron Pope"]
  s.email       = ["cameron@theaboutbox.com"]
  s.homepage    = "http://github.com/theaboutbox/migrant"
  s.summary     = %q{Take your Vagrant to the Cloud}
  s.description = %q{A simple and opinionated way to replicate a Vagrant setup on EC2 or Rackspace}

  s.rubyforge_project = "migrant-boxes"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = ['migrant']
  s.require_paths = ["lib"]

  s.add_dependency 'thor'
  s.add_dependency 'fog'
  s.add_dependency 'vagrant'
  s.add_dependency 'configuration'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-cucumber'
  s.add_development_dependency 'rb-fsevent' if RUBY_PLATFORM =~ /darwin/
  s.add_development_dependency 'growl_notify' if RUBY_PLATFORM =~ /darwin/
end
