require 'date'
require 'time'

module RMyBackup
  def self.purge_days(path,days=false)
    return true unless days
    Dir["#{path}/*.sql.gz"].each do |file|
      mtime = File.mtime(File.expand_path(file))
      mdate = Date.parse("#{mtime.year}-#{mtime.month}-#{mtime.day}")
      date = Date.today - days
      if mdate < date
        puts "Cleaning up - #{file}"
        File.delete(file)
      end
    end
  end

  def self.purge_number(path,number=false)
    #Only keep x backups
  end
end
