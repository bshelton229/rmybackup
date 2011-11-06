module RMyBackup
  class Base
    class << self
      #Edit config Options
      def editor
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
    end
  end
end
