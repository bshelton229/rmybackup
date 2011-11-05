module RMyBackup
  class Push
    class << self
      def run
        #Load the config options
        @config ||= RMyBackup::Configuration.instance
        #Iterrate through the pushes in the @config options
        @config.push.each do |push|
          puts "\nPushing to : #{push} -->\n\n"
          system "#{@config.bin[:rsync]} -rtz --delete #{@config.backup_dir}/ #{push}"
        end
      end
    end
  end
end
