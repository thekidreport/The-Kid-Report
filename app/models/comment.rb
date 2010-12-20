class Comment < ActiveRecord::Base
    belongs_to :page
    belongs_to :user
    
    validates_presence_of :body
    
    before_save :strip_body, :set_last_edited_at
    
    def strip_body
      self.body.strip!
    end
    
    def set_last_edited_at
      self.page.update_attribute(:last_edited_at, Time.now)
      self.page.site.update_attribute(:last_edited_at, Time.now)
    end
end