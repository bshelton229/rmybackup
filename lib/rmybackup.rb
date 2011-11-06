require 'time'
require 'yaml'
require 'rmybackup/install_config'
require 'rmybackup/version'

#Load our libraries
module RMyBackup
  autoload :Backup,         'rmybackup/backup'
  autoload :Base,           'rmybackup/base'
  autoload :Cli,            'rmybackup/cli'
  autoload :Configuration,  'rmybackup/configuration'
  autoload :Purge,          'rmybackup/purge'
  autoload :Push,           'rmybackup/push'
end
