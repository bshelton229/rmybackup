#RakeFile
$:.unshift File.expand_path('../lib',__FILE__)
require 'rmybackup'
require 'rmybackup/backup_sync'

#Used for testing
task :run_backups do
  RMyBackup::Base.new(File.expand_path("~/.rmybackup.conf"))
end

task :btest do
  RMyBackup.bt
end