require 'yaml'
require 'time'

#Load our libraries
Dir[File.expand_path('../rmybackup/*.rb',__FILE__)].each {|file| require file }

# Try to load mysql or mysql2
begin
  require 'mysql2'
  RMyBackup::Base.get_databases_via = 'mysql2'
rescue LoadError
  require 'mysql'
  RMyBackup::Base.get_databases_via = 'mysql'
end
