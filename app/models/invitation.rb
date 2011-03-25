class Invitation < ActiveRecord::Base
  
  belongs_to :site
  
  validates_format_of :email, :with => /^[a-zA-Z0-9.\+_%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/, :if => :email
  
  validates_uniqueness_of :email, :scope => :site_id
  
  validate :not_a_member
  
  after_create :create_member_if_user
  
  def not_a_member
    self.errors.add_to_base("This email is already a member") if self.site.users.find_by_email(self.email).present?
  end
  
  def create_member_if_user
    if user = User.find_by_email(self.email)
      self.site.memberships.create(:user => user, :passcode => self.site.passcode, :role => Role.member)
    end
  end
  
end