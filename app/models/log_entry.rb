class LogEntry < ActiveRecord::Base

    belongs_to :site
    belongs_to :loggable, :polymorphic => true
    belongs_to :user
    
    scope :recent, where('log_entries.created_at > ?', 1.hour.ago)
    scope :page_update, where("description = 'page_update'")

    after_save :set_last_edited_at
    
    def friendly_description
      case self.description
      when 'site_create'
        'created this site and the page'
      when 'site_update'
        'updated the site preferences'
      when 'page_update'
        'edited the page'
      when 'page_create'
        'created the page'
      when 'page_delete'
        'deleted the page'
      when 'event_create'
        'created the event'
      when 'comment_create'
        'created a comment for the page'
      when 'comment_delete'
        'deleted a comment on the page'
      else
        "took the '#{self.description.humanize}' action"
      end
    end
    
    def set_last_edited_at
      self.loggable.page.update_attribute(:last_edited_at, Time.now) if self.loggable.respond_to?(:page) && self.loggable.page
      self.site.update_attribute(:last_edited_at, Time.now) if self.site
    end
    
    def hash
      "#{user_id}#{site_id}#{description}#{loggable_id}".hash
    end

    def eql?(comparee)
      self == comparee
    end

    def ==(comparee)
      self.hash == comparee.hash
    end

end