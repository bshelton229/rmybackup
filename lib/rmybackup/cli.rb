require 'optparse'

module RMyBackup
  class Cli
    def self.run
      options = Hash.new
      #Default edit or list options to false
      options[:edit] = false
      options[:list] = false

      #Process the command line arguments
      ARGV.options do |opts|
        #Set the config file
        opts.on("-f /etc/rmybackup.conf", "--config-file /etc/rmybackup.conf", "Set Config File", String) do |o|
          options[:config_file] = o
        end
        #Version
        opts.on("-v","--version","Outputs version") { puts "Version - #{RMyBackup::VERSION}"; exit }
        # Allow the user to write the sample config file to either the default (no file specified) or
        # to the file they specify on the command line
        opts.on("-i [config_file location]", "--install-config [config_file location]", "Generates a sample config file", String) do |ic|
          RMyBackup.install_config(ic)
          exit 0
        end
        opts.on("-l","--list","Lists the configuration file") {
          #Set the list option to true
          options[:list] = true
        }
        opts.on("-e","--edit","Edit the configuration file in vim, or the editor defined by the system variable $EDITOR") {
          #Set the list option to true
          options[:edit] = true
        }
        opts.parse!
      end

      #The first remaining ARGV, we'll take as a command
      command = ARGV.shift
      #Evaluate edit or list options
      if options[:list]
        RMyBackup.list_config_file(File.expand_path(options[:config_file]))
        exit 0
      end
      if options[:edit]
        RMyBackup.edit_config_file(File.expand_path(options[:config_file]))
        exit 0
      end
      #Load up the config file. This will exit 1 if the config file can't be found
      config = options[:config_file] ? RMyBackup::Configuration.load(options[:config_file]) : RMyBackup::Configuration.instance
      RMyBackup::Backup.run
    end
  end
end
