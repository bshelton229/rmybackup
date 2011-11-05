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
    attr_reader :file, :config, :host, :socket, :username, :password, :backup_dir, :skip_databases, :bin, :options

    # Load the configuration from disk
    def initialize(opts={})
      local_config = File.expand_path("~/.rmybackup.conf")
      central_config = "/etc/rmybackup.conf"
      file = opts[:file] || ( File.exist?(local_config) ? local_config : central_config )
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
      # TODO: validate that this is an array
      @skip_databases = @config['skip_databases']
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

    # Build a connection hash for
    def connection_hash
      out = { :username => @username, :password => @password }
      if @socket
        out[:socket] = @socket
      else
        out[:host] = @host
      end
      out
    end

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

    def db_backup_dir(db)
      File.expand_path("#{@backup_dir}/#{db}")
    end
  end
end
