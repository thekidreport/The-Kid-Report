class Comment < ActiveRecord::Base
    belongs_to :page
    belongs_to :user
    has_many :log_entries, :as => :loggable
    has_many :messages
    
    validates_presence_of :body
    
    before_save :strip_body
    after_save :create_message
    
    def strip_body
      self.body.strip!
    end
    
    def create_message
      self.messages.create(:site => self.page.site, :subject => "A comment from #{self.user.name}", :body => self.body)
    end
    
end