require 'yaml'
require 'time'

class RMyBackup
    
  def initialize(config_file)
    @config_file = config_file
    #if the config file passes, run the backups
    run_backups if parse_config
  end
  
  #Install a baseline config file from the template
  def self.install_config(file=false)
    #Default the file location
    file = "/etc/rmybackup.conf" if not file
    file = File.expand_path(file)

    if File.exists? file
      puts "The file already exists, do you want to overwrite it? (Y/Yes):"
      STDOUT.flush
      answer = gets.chomp
      exit 1 unless answer.upcase == "Y" or answer.upcase == "YES"
    end

    config_file = <<CONFIG_FILE
#Configuration File in YAML format

#Backup Directory
backup_dir: /Users/bshelton/mysql_tmp/

#Databases to back up
databases: [
  databases_here,
  in,
  list
]

#Command Locations
#mysqldump_command: /usr/local/mysql/bin/mysqldump
#gzip_command: /usr/bin/gzip
#find_command: /usr/bin/find
CONFIG_FILE
      
    puts "Installing #{file}"

    begin
      File.open(file,'w') {|f| f.write(config_file) }
    rescue
      puts "Can't write to - #{file}"
    end
    exit 0
  end
  
  private
  #Run the backups, we should have proper validation at this point
  def run_backups
    #Grab some config variables
    mysql_dump = @config['mysqldump_command']
    backup_dir = @config['backup_dir']
    gzip = @config['gzip_command']
    date_string = Time.now.strftime "%m_%d_%Y_%H_%M"

    #Cycle through databases to backup
    @config['databases'].each do |db|
      puts "Backing up #{db}\n"
      system "#{mysql_dump} #{db} |#{gzip} > #{backup_dir}/#{db}_#{date_string}.sql.gz"
    end
  end
  
  #Parse the config YAML file
  def parse_config
    @config = YAML::load(File.open(@config_file))

    #Initialize error array
    @error = Array.new 
    
    #Defaults
    @config['gzip_command'] = "/usr/bin/gzip" if @config['gzip_command'].nil?
    @config['mysqldump_command'] = "/usr/bin/mysqldump" if @config['mysqldump_command'].nil?
    @config['find_command'] = "/usr/bin/find" if @config['find_command'].nil?

    #Backup dir validation
    if not File.directory? @config['backup_dir']
      @error << "No Such Backup Directory #{@config['backup_dir']}"
    else
      @config['backup_dir'] = File.expand_path @config['backup_dir']
      if not File.writable? @config['backup_dir']
        @error << "Can't write to the backup directory - #{@config['backup_dir']}"
      end
    end

    #Check Commands
    @error << "Can't locate find command: #{@config['find_command']}" unless File.exists? @config['find_command']
    @error << "Can't locate gzip command: #{@config['gzip_command']}" unless File.exists? @config['gzip_command']
    @error << "Can't locate mysqldump command: #{@config['mysqldump_command']}" unless File.exists? @config['mysqldump_command']

    #See if we've created any errors, if so, display them and exit
    if @error.empty?
      return true
    else
      @error.each {|e| puts "#{e}\n" }
      exit 1
    end
  #Rescue anything by displaying errors if we have them and exiting 1
  rescue
    @error.each {|e| puts "#{e}\n" }
    exit 1
    return false
  end
end