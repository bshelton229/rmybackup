#RakeFile
$:.unshift File.expand_path('../lib',__FILE__)
require 'rmybackup'
require 'rubygems'
require 'rspec/core/rake_task'
require "bundler/gem_tasks"

# Load the rpsec rake tasks
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fs --color)
  t.pattern = 'spec/**/*.rb'
end

#Run the backups using the config file in your home folder
desc "Run Backups"
task :run_backups do
  RMyBackup::Base.load_config(File.expand_path("~/.rmybackup.conf"))
  RMyBackup::Backup.run
end

#Version
desc "Show Version"
task :version do
  puts RMyBackup::VERSION
end

task :default => :spec
