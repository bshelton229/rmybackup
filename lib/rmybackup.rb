#Require Yaml
require 'yaml'

class RMyBackup
  def initialize(config_file)
    @config_file = config_file
    #if the config has been parsed correctly, run the backups
    run_backups if parse_config
  end
  
  private
  #Run the backups, we should have proper validation at this point
  def run_backups

    #Grab some config variables
    mysql_dump = @config['mysqldump_command']
    backup_dir = @config['backup_dir']

    #Cycle through databases
    puts "We're going to backup\n--------------------"
    @config['databases'].each do |db|
      puts "#{db}\n"
    end
  end
  
  def parse_config
    @config = YAML::load(File.open(@config_file))
    #Now we need to check the config variables, make sure they're right, sanitize them, etc
    return true
  rescue
    return false
  end
end