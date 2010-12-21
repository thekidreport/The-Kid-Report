class LogEntry < ActiveRecord::Base

    belongs_to :site
    belongs_to :page_archive
    belongs_to :user
    
    scope :recent, where('created_at > ?', 1.hour.ago)
    scope :unique, group(:user_id, :page_archive_id, :description, :site_id).select('user_id, page_archive_id, description, site_id')
    
    after_save :set_last_edited_at
    
    def friendly_description
      case self.description
      when 'site_create'
        'created this site and the page'
      when 'site_update'
        'Updated the site preferences'
      when 'page_edit'
        'edited the page'
      when 'page_create'
        'created the page'
      when 'page_delete'
        'deleted the page'
      when 'comment_create'
        'created a comment for the page'
      when 'comment_delete'
        'deleted a comment on the page'
      else
        "Took the '#{self.description.humanize}' action"
      end
    end
    
    def set_last_edited_at
      self.page_archive.page.update_attribute(:last_edited_at, Time.now) if self.page_archive && self.page_archive.page
      self.site.update_attribute(:last_edited_at, Time.now) if self.site
    end

end