module RMyBackup
  class Backup
    #The main method of the Backup class
    def self.run
      # Load the straight config from the base instance
      @config = RMyBackup::Configuration.instance
      #Cycle through databases to backup
      get_databases.each do |db|
        # Handle the backup directory creation
        backup_dir = @config.db_backup_dir(db)
        Dir.mkdir(backup_dir) if not File.exists?(backup_dir)
        puts "Backing up #{db}\n"
        command = @config.backup_command(db)
        %x(#{command})
        #Purge after x days
        RMyBackup::Purge.days(db)
        RMyBackup::Purge.number(db)
      end
      #If we need to push the dir, push it here
      RMyBackup::Push.run if not @config.push.empty?
    end

    private

    #Get the databases from the mysql server, less the databases in the skip_databases definition
    #in the config files
    def self.get_databases
      @config ||= RMyBackup::Configuration.instance
      # Connection
      mysql_client = Mysql2::Client.new(@config.connection_hash)
      #Run the query and remove the skipped databases, this will return
      mysql_client.query("SHOW DATABASES").each(:symbolize_keys => true).collect {|db| db[:Database] } - @config.skip_databases
    rescue
      puts "There was a problem connecting to the mysql server"
      exit 1
    end
  end
end