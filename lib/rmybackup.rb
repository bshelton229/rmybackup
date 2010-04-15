#Require Yaml
require 'yaml'

class RMyBackup
  def initialize(config_file)
    @config_file = config_file
    parse_config
    @config['databases'].each {|db| puts "DB - #{db}\n" }
  end
  
  def parse_config
   @config = YAML::load(File.open(@config_file))
  end
end