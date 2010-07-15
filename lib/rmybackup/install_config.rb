module RMyBackup
  #Install a baseline config file from the template
  def self.install_config(file=false)
    #Default the file location
    if not file
      if File.writable_real?("/etc/")
        file = "/etc/rmybackup.conf"
      else
        file = "~/.rmybackup.conf"
      end
    end
    
    #Expand the path
    file = File.expand_path(file)
    
    if File.exists? file
      puts "#{file} already exists, do you want to overwrite it? (Y/n):"
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
  
  #Edit config Options
  def self.editor
    if ENV['EDITOR'].nil?
      vim = `which vim`.chop
      if vim.empty?
        return false
      else
        return vim
      end
    else
      return ENV['EDITOR']
    end
  end
  
  def self.list_config_file(file)
    if editor

      #See if the config file exists
      if not File.exists? file
        puts "The config file cannot be found: #{file}"
        exit 1
      end
      
      puts "Showing config file - #{file}:\n"
      File.open(file, "r") do |infile|
        while(line = infile.gets)
          puts line
        end
      end
    else
      puts "Can't locate vim and $EDITOR isn't set"
      exit 1
    end
  end
  
  def self.edit_config_file(file)

    #See if the config file exists
    if not File.exists? file
      puts "The config file cannot be found: #{file}"
      exit 1
    end

    if editor
      exec "#{editor} #{file}"
    else
      puts "Can't locate vim and $EDITOR isn't set"
      exit 1
    end
  end
end
