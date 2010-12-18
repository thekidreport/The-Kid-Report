class Membership < ActiveRecord::Base
    belongs_to :site
    belongs_to :user
    belongs_to :role
    
    attr_accessor :email
    
    before_validation_on_create :set_user
    
    validates_presence_of :user
    validates_presence_of :role
    
    validates_uniqueness_of :user_id, :scope => :site_id, :message => 'is already a member'
    
    def set_user
      if self.email.present? && self.user.nil?
        self.user = User.find_by_email(self.email) || User.create(:email => self.email, :password => (rand(1000000) + 1000000).to_s)
      end
    end
    
    def can_edit?
      return self.role.name == 'editor' || self.role.name == 'admin' 
    end
    
    def can_administrate?
      return self.role.name == 'admin' 
    end

end