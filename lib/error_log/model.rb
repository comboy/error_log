module ErrorLog
   class Model < ActiveRecord::Base

      class Migration < ActiveRecord::Migration
         def self.up
            create_table :error_logs do |t|
               t.text :error
               t.text :backtrace
               t.string :category
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

      before_save do |obj|
         if obj.backtrace.kind_of? Array
            obj.backtrace = obj.backtrace.join("\n")
         end
      end
   end
end
