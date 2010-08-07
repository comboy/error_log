require 'digest/md5'

module ErrorLog
   class Model < ActiveRecord::Base

      class Migration < ActiveRecord::Migration
         def self.up
            create_table :error_logs do |t|
               t.text :error
               t.text :backtrace
               t.string :category
               # note to future me: "hash" is a really bad name for the column
               t.string :error_hash
               t.integer :level_id
               t.timestamp :created_at
               t.boolean :viewed, :default => false
            end
         end
      end 

      self.table_name = 'error_logs'
      unless self.table_exists? 
         Migration.up
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
