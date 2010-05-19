#RakeFile
$:.unshift File.expand_path('../lib',__FILE__)
require 'rmybackup'
require 'rmybackup/backup_sync'

#Run the backups using the config file in your home folder
task :run_backups do
  RMyBackup::Base.new(File.expand_path("~/.rmybackup.conf"))
end

#Version
task :version do
  puts RMyBackup::GEM_VERSION
end