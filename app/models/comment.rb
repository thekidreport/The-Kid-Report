class Comment < ActiveRecord::Base
    belongs_to :page
    belongs_to :user
    
    validates_presence_of :body
    
    before_save :strip_body
    
    def strip_body
      self.body.strip!
    end
end