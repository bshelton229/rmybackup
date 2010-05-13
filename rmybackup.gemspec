Gem::Specification.new do |s|
  s.name = %q{rmybackup}
  s.version = "0.1.2"
  s.date = %q{2010-05-13}
  s.authors = ["Bryan Shelton"]
  s.email = %q{bryan@sheltonopensolutions.com}
  s.summary = %q{Ruby Mysql Backup Script}
  s.homepage = %q{http://github.com/bshelton229/rmybackup/}
  s.description = %q{Ruby mysql backup script, the script uses mysqldump from the system}
  s.executables = ["rmybackup"]
  s.files = [
  "lib/rmybackup.rb",
   "Readme.md",
   "lib/rmybackup/config_file.txt",
   "lib/rmybackup/install_config.rb",
   "lib/rmybackup/purge_files.rb"
  ]
  s.require_path = 'lib'
end