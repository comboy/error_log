require 'digest/md5'

module ErrorLog
   class Model < ActiveRecord::Base

      self.table_name = 'error_logs'

      LEVELS = {
         :debug => 0,
         :info  => 1,
         :warn  => 2,
         :warning  => 2,
         :error => 3,
         :fatal => 4,
         :wtf   => 5
      }

      serialize :params, Hash

      def level
         LEVELS.invert[self.level_id]
      end

      def level=(name)
         self.level_id = LEVELS[name]
      end

      before_save do |obj|
         obj.level ||= :error

         if obj.backtrace.kind_of? Array
            obj.backtrace = obj.backtrace.join("\n")
         end

         obj.error_hash = Digest::MD5.hexdigest(obj.backtrace.to_s + obj.error.to_s + obj.category.to_s)

         obj.vcs_revision = nil if vcs_revision.empty?

         true
      end

   end
end
