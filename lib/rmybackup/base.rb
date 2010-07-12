module RMyBackup
  class Base
    class << self
      #Load the configuration from the file
      def load_config(file)

        #Expand the file path
        file = File.expand_path(file)
        
        if not File.exists? file
          puts "Can't load config file: #{file}"
          exit 1
        end

        #Load the YAML file
        @config = YAML::load(File.open(file))
        
        #Initialize error array
        @error = Array.new 

        #Command locations
        if @config['gzip_command'].nil?
          @config['gzip_command'] = `which gzip`.chop
        end

        if @config['mysqldump_command'].nil?
          @config['mysqldump_command'] = `which mysqldump`.chop
        end
        

        #Sanitize and check our PUSH options
        if not @config['push'].nil?
          #Turn this into an array, even if there is only one in the config file
          @config['push'] = Array.new << @config['push'] if not @config['push'].kind_of? Array

          #Because we have a push defined, lets find the rsync command
          if @config['rsync_command'].nil?
            @config['rsync_command'] = `which rsync`.chop
          end
          
          @error << "Can't locate rsync command: #{@config['rsync_command']}" unless File.exists? @config['rsync_command']          
        else
          @config['push'] = false
        end
        
        #Check that commands exist
        @error << "Can't locate gzip command: #{@config['gzip_command']}" unless File.exists? @config['gzip_command']
        @error << "Can't locate mysqldump command: #{@config['mysqldump_command']}" unless File.exists? @config['mysqldump_command']
  
  
        #Default the purge settings
        @config['remove_after'] = @config['remove_after'] || false
        @config['only_keep'] = @config['only_keep'] || false


        #Default .my.cnf usage
        @config['use_mycnf_credentials'] = @config['use_mycnf_credentials'] ? true : false

        #Database Config
        @config['username'] = @config['username'] || false
        @config['password'] = @config['password'] || false
        @config['host'] = @config['host'] || false


        #Backup dir validation
        @config['backup_dir'] = File.expand_path @config['backup_dir']
        
        if not File.directory? @config['backup_dir']
          @error << "No Such Backup Directory #{@config['backup_dir']}"
        else
          if not File.writable? @config['backup_dir']
            @error << "Can't write to the backup directory - #{@config['backup_dir']}"
          end
        end

        #See if we've created any errors, if so, display them and exit
        if @error.empty?
          return true
        else
          @error.each {|e| puts "#{e}\n" }
          exit 1
        end

      end
      
      def get_config

        #Check to make sure the configuration file has already been loaded
        if not @config
          puts 'No config file has been loaded.'
          exit
        end
        
        @config
      end
    end
  end
end
