class Membership < ActiveRecord::Base
    belongs_to :site
    belongs_to :user
    belongs_to :role
    
    attr_accessor :email, :passcode
    
    before_validation :set_user, :on => :create
    
    validates_presence_of :user
    validates_format_of :email, :with => /^[a-zA-Z0-9.\+_%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/, :if => :email
    
    validates_uniqueness_of :user_id, :scope => :site_id, :message => 'is already a member'
    
    validate :confirm_passcode, :on => :create
    
    def set_user
      if self.email.present? && self.user.nil?
        user = User.find_by_email(self.email) || User.create(:email => self.email, :password => (rand(1000000) + 1000000).to_s)
        self.user_id = user.id
      end
    end
    
    def can_edit?
      return self.role.name == 'editor' || self.role.name == 'admin' 
    end
    
    def can_administrate?
      return self.role.name == 'admin' 
    end
    
    def confirm_passcode
      self.errors.add_to_base 'Wrong passcode' unless self.passcode == self.site.passcode
    end

end