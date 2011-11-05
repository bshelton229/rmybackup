require 'date'
require 'time'

module RMyBackup
  class Purge
    # Remove backups that are older than x days
    def self.days(db)
      @config ||= RMyBackup::Configuration.instance
      path, days = @config.db_backup_dir(db), @config.purge[:remove_after]
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

    # Remove x number of backups
    def self.number(db)
      @config ||= RMyBackup::Configuration.instance
      path, number = @config.db_backup_dir(db), @config.purge[:only_keep]
      return true unless number
      all_files = Dir[File.join(path,"*.gz")].sort_by {|f| File.mtime(f)}.reverse
      keep = all_files[0..number - 1]
      remove = all_files - keep
      remove.each do |f|
        File.delete f
      end
    end
  end
end
