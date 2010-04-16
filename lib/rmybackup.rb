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
    puts @config['backup_dir']
    return true
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

    @error = Array.new
    
    #Defaults
    @config['gzip_command'] = "/usr/bin/gzip" if @config['gzip_command'].nil?
    @config['mysqldump_command'] = "/usr/bin/mysqldump" if @config['mysqldump_command'].nil?
    #Fix Slash at the end of the path
    @config['backup_dir'] += "/" unless @config['backup_dir'][-1,1] == "/"
    #Run Some checks
    @error << "No Such Backup Directory #{@config['backup_dir']}" unless File.directory? @config['backup_dir']    

    if @error.empty?
      return true
    else
      @error.each {|e| puts "#{e}\n" }
      exit
    end
  rescue
    puts "error"
    return false
  end
end