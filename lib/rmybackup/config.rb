module RMyBackup
  #Install a baseline config file from the template
  def self.install_config(file=false)
    #Default the file location
    file = "/etc/rmybackup.conf" if not file
    file = File.expand_path(file)

    if File.exists? file
      puts "The file already exists, do you want to overwrite it? (Y/Yes):"
      STDOUT.flush
      answer = gets.chomp
      exit 1 unless answer.upcase == "Y" or answer.upcase == "YES"
    end

    #Read Sample Config File
    config_file = File.read(File.expand_path("../../rmybackup/config_file.txt",__FILE__))

    begin
      File.open(file,'w') {|f| f.write(config_file) }
      puts "Installing #{file}"
    rescue Errno::EACCES
      puts "Can't write to - #{file}"
    end
    exit 0
  end
end
