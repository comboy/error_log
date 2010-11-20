module ErrorLog
  module Migrations

    # Chack what do we have in database and migratie what's needed
    # Those migrations does not work like rails migrations, I check manually if table exists, 
    # or if given column exist, and add it if it's not there. I didnt want to use rails migrations 
    # to avoid messing with your database, and adding there anything more than the error_logs table 
    # that is needed. Also this way we dont have to care if you still use old kind of numbered 
    # migrations.
    def self.auto_migrate!

      unless Model.table_exists? 
         Base.up
         Model.reset_column_information
      end

      unless Model.column_names.include?('params')
         AddParamsColumn.up
         Model.reset_column_information
      end

      unless Model.column_names.include?('vcs_revision')
         AddVcsRevisionColumn.up
         Model.reset_column_information
      end

    end
  end

end
