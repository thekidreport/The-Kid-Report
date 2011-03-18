class Comment < ActiveRecord::Base
    belongs_to :page
    belongs_to :user
    has_many :log_entries, :as => :loggable
    
    validates_presence_of :body
    
    before_save :strip_body
    
    def strip_body
      self.body.strip!
    end

end