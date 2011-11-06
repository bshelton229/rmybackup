#RakeFile
require 'rubygems'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

# Load the rpsec rake tasks
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fs --color)
  t.pattern = 'spec/**/*.rb'
end

#Version
desc "Show Version"
task :version do
  puts RMyBackup::VERSION
end

task :default => :spec
