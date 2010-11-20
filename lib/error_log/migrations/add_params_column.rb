module ErrorLog
  module Migrations
    # ErrorLog 0.2 to 0.3 migration, creating params column 
    class AddParamsColumn < ActiveRecord::Migration
      def self.up
        add_column :error_logs, :params, :text
      end
    end
  end
end
