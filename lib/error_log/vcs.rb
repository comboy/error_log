module ErrorLog
  # VCS would be a better name, I'm just sticking to rails file and modules naming convention
  module Vcs
    def self.guess
      if File.exists?(File.join(Rails.root,'.git'))
        return :git
      end
      false
    end

    def self.revision
      case ErrorLog.options[:vcs]
      when :git
        git_root = File.join(Rails.root,'.git') 
        head = File.read("#{git_root}/HEAD")
        ref = head.strip.split("ref:",2).last.strip
        hash = File.read("#{git_root}/#{ref}").strip
      else
        ''
      end
    end
  end
end
