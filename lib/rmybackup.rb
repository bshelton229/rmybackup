require 'yaml'
require 'time'
require 'mysql'

#Load our libraries
require File.expand_path('../rmybackup/install_config',__FILE__)
require File.expand_path('../rmybackup/purge_files',__FILE__)
require File.expand_path('../rmybackup/base',__FILE__)
require File.expand_path('../rmybackup/backup',__FILE__)

#Set the version
module RMyBackup
  GEM_VERSION = "0.4.0"
end

if __FILE__ == $0
  RMyBackup::Base.load_config('~/.rmybackup.conf')
  RMyBackup::Backup.run
end
