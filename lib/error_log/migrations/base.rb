module ErrorLog
  module Migrations
    # Base migration, create error_logs table
    class Base < ActiveRecord::Migration
      def self.up
        create_table :error_logs do |t|
          t.text :error
          t.text :backtrace
          t.string :category
          t.string :error_hash
          t.integer :level_id
          t.timestamp :created_at
          t.boolean :viewed, :default => false
        end

        add_index :error_logs, :category
      end
    end 
  end
end
