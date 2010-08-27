require 'yaml'
require 'time'
require 'mysql2'

#Load our libraries
Dir[File.expand_path('../rmybackup/*.rb',__FILE__)].each {|file| require file }

#Set the version
module RMyBackup
  GEM_VERSION = "0.4.0"
end
