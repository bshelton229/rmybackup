require 'yaml'
require 'time'
require 'mysql'

require File.expand_path('../rmybackup/install_config',__FILE__)
require File.expand_path('../rmybackup/purge_files',__FILE__)

module RMyBackup

  GEM_VERSION = "0.2.0"
  
  class Base
    def initialize(config_file)
      @config_file = config_file
      #if the config file passes, run the backups
      run_backups if parse_config
    end
  
    private
    #Run the backups, we should have proper validation at this point
    def run_backups
      
      #Grab some config variables
      mysql_dump = @config['mysqldump_command']
      backup_root = @config['backup_dir']
      gzip = @config['gzip_command']
      date_string = Time.now.strftime "%m_%d_%Y_%H_%M"

      
      #Cycle through databases to backup
      get_databases.each do |db|
        backup_dir = File.expand_path("#{backup_root}/#{db}")
        Dir.mkdir(backup_dir) if not File.exists?(backup_dir)

        puts "Backing up #{db}\n"
        system "#{mysql_dump} --user=#{@config['username']} --password=#{@config['password']} --host=#{@config['host']} #{db} |#{gzip} > #{backup_dir}/#{db}_#{date_string}.sql.gz"

        #Purge after x days
        RMyBackup.purge_days(backup_dir,@config['remove_after'])
      end
      

    end
    
    #Get Databases from MySQL
    def get_databases
      dbc = Mysql.real_connect(@config['host'],@config['username'],@config['password'])
      res = dbc.query('SHOW DATABASES;')
      databases = []
      res.each_hash do |db|
        databases << db['Database']
      end
      return databases - @config['skip_databases']
    rescue
      puts "There was a problem connecting to the mysql server"
      exit 0
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
      @config['remove_after'] = @config['remove_after'] || false

      #Database Config
      @config['username'] = @config['username'] || false
      @config['password'] = @config['password'] || false
      @config['host'] = @config['host'] || false

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
end