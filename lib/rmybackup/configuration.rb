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

    attr_reader :file
    attr_reader :config

    # Load the configuration from disk
    def initialize(opts={})
      local_config = File.expand_path("~/.rmybackup.conf")
      central_config = "/etc/rmybackup.conf"
      file = opts[:file] || ( File.exist?(local_config) ? local_config : central_config )
      @file = File.expand_path(file)
      if not File.exist? file
        raise "Can't load the config file #{file}"
      end
      @config = YAML::load(File.open(@file))
    end
  end
end
