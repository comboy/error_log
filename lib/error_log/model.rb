require 'digest/md5'

module ErrorLog
   class Model < ActiveRecord::Base

      self.table_name = 'error_logs'

      # Migrate database if needed
      unless self.table_exists? 
         Migration.up
         reset_column_information
      end

      # Upgrade if needed
      unless column_names.include?('params')
         UpgradeMigration1.up
         reset_column_information
      end

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
      attr_accessor :count # used in grouping 

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

         true
      end

   end
end
