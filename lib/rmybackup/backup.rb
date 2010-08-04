module RMyBackup
  class Backup
    def self.run

      #This will exit out if RMyBackup::Base.load_config(file) hasn't been loaded with a config file yet
      @config = RMyBackup::Base.get_config

      #Grab some config variables
      mysql_dump = @config['mysqldump_command']
      backup_root = @config['backup_dir']
      gzip = @config['gzip_command']
      date_string = Time.now.strftime "%m_%d_%Y_%H_%M"

      
      #Cycle through databases to backup
      get_databases.each do |db|
        backup_dir = File.expand_path("#{backup_root}/#{db}")
        Dir.mkdir(backup_dir) if not File.exists?(backup_dir)

        #Decide if we use my.cnf or creds on cli
        if @config['use_mycnf_credentials']
          cred_string = ''
        else
          cred_string = " --user=#{@config['username']} --password=#{@config['password']} --host=#{@config['host']}"
        end
        
        puts "Backing up #{db}\n"
        system "#{mysql_dump}#{cred_string} #{db} |#{gzip} > #{backup_dir}/#{db}_#{date_string}.sql.gz"
        
        #Purge after x days
        RMyBackup.purge_days(backup_dir,@config['remove_after'])
        RMyBackup.purge_number(backup_dir,@config['only_keep'])
      end
      
      #If we need to push the dir, push it here
      RMyBackup::Push.run if @config['push']
    end
    
    private
    
    #Get Databases from MySQL
    def self.get_databases
      # dbc = Mysql.real_connect(@config['host'],@config['username'],@config['password'])
      # res = dbc.query('SHOW DATABASES;')
      # databases = []
      # res.each_hash do |db|
      #   databases << db['Database']
      # end
      # return databases - @config['skip_databases']
      mysql_client = Mysql2::Client.new(:host => @config['host'], :username => @config['username'], :password => @config['password'])
      mysql_client.query("SHOW DATABASES").each(:symbolize_keys => true).collect {|db| db[:Database] } - @config['skip_databases']
    rescue
      puts "There was a problem connecting to the mysql server"
      exit 0
    end
    
  end
end