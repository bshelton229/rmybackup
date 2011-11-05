require 'yaml'

module RMyBackup
  class Configuration
    @@config = false

    # Load the configuration from a specified file
    def self.load(file)
      @@config = self.new(:file => file)
    end

    # Get config
    def self.instance
      @@config ||= self.new
    end

    # Reading is good for you
    attr_reader :file, :config, :host, :socket, :username, :password, :backup_dir, :skip_databases, :push, :bin, :options

    # Load the configuration from disk
    def initialize(opts={})
      # Find the appropriate config file
      file = opts[:file] || find_config
      raise "Couldn't find a suitable config file" if not file
      @file = File.expand_path(file)
      if not File.exist? file
        raise "Can't load the config file #{file}"
      end
      # Load the raw processed yaml into the cnofig instance variable
      @config = YAML::load(File.open(@file))
      # Set class variables
      @host = @config['host']
      @username = @config['username']
      @password = @config['password']
      @backup_dir = @config['backup_dir']
      @socket = @config['socket']
      # TODO: Validate skip_databases and push
      @skip_databases = @config['skip_databases'] || Array.new
      # Run the private method to set @push
      set_push
      # Binaries
      @bin = {
        :mysqldump => @config['mysqldump_command'] || 'mysqldump',
        :gzip => @config['gzip_command'] || 'gzip',
        :rsync => @config['rsync_command'] || 'rsync'
      }
      # Miscelaneous other options
      @options = {
        :use_mycnf_credentials => @config['use_mycnf_credentials'] || false
      }
    end

    # Build a connection hash for the database drivers
    def connection_hash
      out = { :username => @username, :password => @password }
      if @socket
        out[:socket] = @socket
      else
        out[:host] = @host
      end
      out
    end

    # Build the mysqldump command line argument list
    # to be appended to the backup_command
    def args
      args = Array.new
      # Add command line authentication args if we're not
      # ignoring them in favor of whatever is set in my.cnf
      if not @options[:use_mycnf_credentials]
        args << "--user=#{@username}"
        args << "--password=#{@password}"
        # Deal with SOCKET or TCP
        if @socket
          args << "--protocol=SOCKET"
          args << "--socket=#{@socket}"
        else
          args << "--protocol=TCP"
          args << "--host=#{@host}"
        end
      end
      args.empty? ? nil : " #{args.join(' ')}"
    end

    # Render the command to use for the backup
    def backup_command(db)
      backup_dir = db_backup_dir(db)
      date_string = Time.now.strftime "%Y_%m_%d_%H_%M"
      "#{@bin[:mysqldump]}#{args} #{db} |#{@bin[:gzip]} > #{backup_dir}/#{db}_#{date_string}.sql.gz"
    end

    # Return the backup directory for a particular database
    def db_backup_dir(db)
      File.expand_path("#{@backup_dir}/#{db}")
    end

    private
    # Set the @push instance variable
    # Do several checks first
    def set_push
      @push = Array.new
      @config['push'] = (Array.new << @config['push']) if @config['push'].kind_of?(String)
      if @config['push']
        @config['push'].each do |push|
          push.gsub!(/\s+$/, '')
          push.gsub!(/^\s+/, '')
          push << "/" if not push.match /\/$/
          @push << push
        end
      end
    end

    # Find a configuration file
    def find_config
      # Search for configuration files in this order
      try_files = %w(~/.rmybackup.yml ~/.rmybackup.conf /etc/rmybackup.yml /etc/rmybackup.conf)
      try_files.each do |f|
        file = File.expand_path(f)
        return file if File.exist?(file)
      end
      false
    end
  end
end
