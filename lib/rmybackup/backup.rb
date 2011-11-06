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

    # Get the driver we're going to use to pull the databases
    def self.get_driver
      try = %w(mysql2 mysql)
      try.each do |driver|
        begin
          require driver
          return driver
        rescue LoadError
          next
        end
      end
      return false
    end

    #Get the databases from the mysql server, less the databases in the skip_databases definition
    #in the config files
    def self.get_databases
      @config ||= RMyBackup::Configuration.instance
      driver = get_driver or raise 'Could not load either the mysql2 or mysql driver'
      # Use either the mysql2 gem or the mysql gem
      if driver == "mysql2"
        mysql_client = Mysql2::Client.new(@config.connection_hash)
        return mysql_client.query("SHOW DATABASES").each(:symbolize_keys => true).collect {|db| db[:Database] } - @config.skip_databases
      else
        # This will be the mysql gem
        mysql_client = Mysql.real_connect(@config.host, @config.username, @config.password, nil, @config.port, @config.socket)
        databases = Array.new
        res = mysql_client.query("SHOW DATABASES")
        res.each_hash do |db|
          databases << db['Database']
        end
        return databases - @config.skip_databases
      end
    end
  end
end
