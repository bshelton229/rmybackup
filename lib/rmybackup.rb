require 'yaml'
require 'time'
require 'mysql2'

#Load our libraries
Dir[File.expand_path('../rmybackup/*.rb',__FILE__)].each {|file| require file }
