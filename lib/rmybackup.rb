require 'time'
require 'rmybackup/install_config'
require 'rmybackup/purge_files'
require 'rmybackup/push'

#Load our libraries
module RMyBackup
  autoload :Base,           'rmybackup/base'
  autoload :Backup,         'rmybacukp/backup'
  autoload :Cli,            'rmybackup/cli'
  autoload :Configuration,  'rmybackup/configuration'
  autoload :Push,           'rmybackup/push'
end

# Try to load mysql or mysql2
begin
  require 'mysql2'
  RMyBackup::Base.get_databases_via = 'mysql2'
rescue LoadError
  require 'mysql'
  RMyBackup::Base.get_databases_via = 'mysql'
end

