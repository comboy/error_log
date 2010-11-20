module ErrorLog
  module Migrations
    # ErrorLog 0.2 to 0.3 migration, creating params column 
    class AddVcsRevisionColumn < ActiveRecord::Migration
      def self.up
        add_column :error_logs, :vcs_revision, :string
      end
    end
  end
end
