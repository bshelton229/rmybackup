module RMyBackup
  class Push
    class << self
      def run
        #Load the config options
        @config = RMyBackup::Base.get_config
        
        puts "COUNT - #{@config['push'].count}"
        #Iterrate through the pushes in the @config options
        @config['push'].each do |push|
          #Define the rsync_command from the @config option
          rsync_command = @config['rsync_command']
          
          #Add a trailing slash if not present
          push += "/" if push[-1,1] != "/"
          
          puts "\nPushing to : #{push} -->\n\n"
          system "#{rsync_command} -r --delete #{@config['backup_dir']}/ #{push}"
        end
        
      end
    end
  end
end
