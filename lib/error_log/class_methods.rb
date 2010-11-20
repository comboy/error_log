module ErrorLog
  module ClassMethods

    def options
      @options ||= {
        :vcs => Vcs.guess
      }
    end

    # Log error, exception, or whatever you have on your mind
    #
    # Args:
    #   * level - error level {:debug, :info, :warn, :error, :fatal}
    #   * error - error string itself
    #   * options 
    #
    # Possible options:
    #   * :backtrace 
    #   * :params - params that can help you recreate this error, Hash
    #   * :category - error category, helps you to group them later
    #
    def log(level,error,options={})
      backtrace = options[:backtrace]
      unless backtrace
        begin
          # I'm raising an exception just to get the current backtrace
          # If there is any more clever way to do that, please share.
          raise "wat?!"
        rescue Exception => e
          backtrace = e.backtrace[1..-1]
        end
      end

      # Silent rescues may not be optimal, for now they seem better than creating more mess
      logger.error "\n\n\n#{Time.now}\n= #{error}\n#{backtrace.join("\n")}\n#{options[:params]}" rescue nil

      ErrorLog::Model.create(
        :error => error,
        :backtrace => backtrace,
        :level => level,
        :params => options[:params],
        :vcs_revision => current_revision,
        :category => options[:category] || 'error_log'
      ) rescue nil 
    end

    # Errors log, may be useful when you're facing some db related problems
    def logger
      @logger = Logger.new(File.join(Rails.root,'log','error.log'))
    end

    def init
      @current_revision = Vcs.revision
      Migrations.auto_migrate!
    end

    def current_revision
      @current_revision
    end

  end

  class << self
    include ClassMethods
  end
end
