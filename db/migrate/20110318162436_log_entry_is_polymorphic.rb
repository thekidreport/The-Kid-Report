class LogEntryIsPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :log_entries, :page_archive_id, :loggable_id
    add_column :log_entries, :loggable_type, :string
    
    LogEntry.update_all "loggable_type = 'PageArchive'", "description = 'page_create' OR description = 'page_edit'"
    LogEntry.update_all "loggable_type = 'Comment'", "description = 'comment_create'"
    LogEntry.update_all "loggable_type = 'Site'", "description = 'site_create' OR description = 'site_update'"
    LogEntry.update_all("description = 'page_update'", "description = 'page_edit'")
  end

  def self.down
    rename_column :log_entries, :page_archive_id, :loggable_id
    add_column :log_entries, :loggable_type
  end
end
