$:.unshift File.expand_path('../lib',__FILE__)
require 'rmybackup'

Gem::Specification.new do |s|
  s.name = "rmybackup"
  s.version = RMyBackup::GEM_VERSION
  s.authors = ["Bryan Shelton"]
  s.email = "bryan@sheltonopensolutions.com"
  s.summary = "Ruby Mysql Backup Script"
  s.homepage = "http://github.com/bshelton229/rmybackup/"
  s.description = "Ruby mysql backup script, the script uses mysqldump from the system"
  s.executables = ["rmybackup"]
  s.files = Dir['Readme.md','lib/**/*','bin/*']
  s.require_path = "lib"
  
  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "mysql2", ">= 0.2.3"
  
  s.add_development_dependency "rspec"
end
