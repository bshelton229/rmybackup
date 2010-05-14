$:.unshift File.expand_path('../lib',__FILE__)
require 'rmybackup'

Gem::Specification.new do |s|
  s.name = "rmybackup"
  s.version = RMyBackup::GEM_VERSION
  s.date = "2010-05-13"
  s.authors = ["Bryan Shelton"]
  s.email = "bryan@sheltonopensolutions.com"
  s.summary = "Ruby Mysql Backup Script"
  s.homepage = "http://github.com/bshelton229/rmybackup/"
  s.description = "Ruby mysql backup script, the script uses mysqldump from the system"
  s.executables = ["rmybackup"]
  s.files = [
    "lib/rmybackup.rb",
    "Readme.md",
    "lib/rmybackup/config_file.txt",
    "lib/rmybackup/install_config.rb",
    "lib/rmybackup/purge_files.rb"
  ]
  s.require_path = "lib"
  s.add_dependency("mysql")
end