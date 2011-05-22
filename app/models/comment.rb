class Comment < ActiveRecord::Base
  
    belongs_to :page
    belongs_to :user
    has_many :log_entries, :as => :loggable
    has_one :message
    
    validates_presence_of :body
    
    validate :stop_double_click
    
    before_save :strip_body
    
    def strip_body
      self.body.strip!
    end
    
    def stop_double_click
      errors.add_to_base('The comment was posted') if Comment.find(:first, :conditions => ['body = ? AND user_id = ? AND created_at > ?', self.body, self.user_id, 1.minute.ago])
    end
    
end