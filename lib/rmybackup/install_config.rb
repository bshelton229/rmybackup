module RMyBackup
  #Install a baseline config file from the template
  def self.install_config(file=false)
    #Default the file location
    if not file
      if File.writable_real?("/etc/rmybackup.conf")
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
    editor = `echo $EDITOR`.chop
    if editor.empty?
      vim = `which vim`.chop
      if vim.empty?
        return false
      else
        return vim
      end
    else
      return editor
    end
  end
  
  def self.list_config_file
    if editor
      config = RMyBackup::Base.get_config
      file = config['file']
      puts "Showing config file - #{file}:\n\n"
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
  
  def self.edit_config_file
    config = RMyBackup::Base.get_config
    if editor
      exec "#{editor} #{config['file']}"
    else
      puts "Can't locate vim and $EDITOR isn't set"
      exit 1
    end
  end
end
