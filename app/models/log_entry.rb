class LogEntry < ActiveRecord::Base

    belongs_to :site
    belongs_to :page_archive
    belongs_to :user
    
    scope :recent, where('created_at > ?', 1.hour.ago)
    scope :unique, group(:user_id, :page_archive_id, :description).select('user_id, page_archive_id, description')
    
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
      when 'comment_edit'
        'updated comment on the page'
      when 'comment_create'
        'created a comment for the page'
      when 'comment_delete'
        'deleted a comment on the page'
      else
        "Took the '#{self.description.humanize}' action"
      end
    end

end