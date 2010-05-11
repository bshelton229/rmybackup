require 'date'
require 'time'

module RMyBackup
  def self.purge_files(dir,days=1)
    Dir.open(dir).each do |file|
      unless file == '.' or file == '..'
        fileloc = File.expand_path(dir)+"/"+file
        mt = File.mtime(fileloc)
        #Create a date from the timestamp
        file_date = Date.new(mt.year,mt.month,mt.day)
        if file_date < (file_date - 5)
          puts "Would remove file - #{file}"
        end
      end
    end
  end
end
