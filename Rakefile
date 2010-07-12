#RakeFile
$:.unshift File.expand_path('../lib',__FILE__)
require 'rmybackup'

#Run the backups using the config file in your home folder
task :run_backups do
  RMyBackup::Base.load_config(File.expand_path("~/.rmybackup.conf"))
  RMyBackup::Backup.run
end

#Version
task :version do
  puts RMyBackup::GEM_VERSION
end
