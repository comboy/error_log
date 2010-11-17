module ErrorLog

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

      add_index :error_hash
    end
  end 

  class UpgradeMigration1 < ActiveRecord::Migration
    def self.up
      add_column :error_logs, :params, :text
    end
  end

end
