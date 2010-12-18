class Message < ActiveRecord::Base
    belongs_to :site
    belongs_to :user
    
    has_many :message_recipients
    has_many :users, :through => :message_recipients
    
    validates_presence_of :subject, :body
    validates_presence_of :user_ids

end