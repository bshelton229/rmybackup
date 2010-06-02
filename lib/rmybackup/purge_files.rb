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
    return true unless number
    all_files = Dir[File.join(path,"*.gz")].sort_by {|f| File.mtime(f)}.reverse
    keep = all_files[0..number - 1]
    remove = all_files - keep
    remove.each do |f|
      File.delete f
    end
  end
end
