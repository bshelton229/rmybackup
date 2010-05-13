#RakeFile
$:.unshift File.expand_path('../lib',__FILE__)
require 'rmybackup'

#Used for testing
task :run_backups do
  RMyBackup::Base.new(File.expand_path("~/.rmybackup.conf"))
end
