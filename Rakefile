require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new

task :default => :spec

