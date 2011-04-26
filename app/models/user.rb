require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :phone
  
  has_many :memberships, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :log_entries, :dependent => :nullify
  has_many :sites, :through => :memberships
  has_many :invitations, :foreign_key => :email, :primary_key => :email

	EMAIL_REGEX = /([_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name)))/

  scope :not_deleted, where('users.deleted_at is null')
	
	before_save :reset_deleted_at, :set_name, :ensure_authentication_token
	after_create :set_memberships

	def display_name
		if self.name.present?
			return self.name
		elsif email && email.include?('@')
			return email.split('@')[0].humanize 
		else
			return "Friend"
		end
	end
	
	def set_name
	  unless self.name.present?
	    self.name = self.display_name 
	    self.save
    end
  end
	
	def member_of? site
	  site.users.not_deleted.include?(self) || self.admin?
  end
	
	def can_edit? site
	  site.editors.not_deleted.include?(self) || self.admin?
  end
  
  def can_admin? site
    site.admins.not_deleted.include?(self) || self.admin?
  end
  
  def delete!
    if self.last_sign_in_at
      self.deleted_at = Time.now
      self.save
    else
      self.destroy
    end
  end
  
  def reset_deleted_at
    if self.last_sign_in_at && self.deleted_at && self.last_sign_in_at > self.deleted_at
      self.deleted_at = nil
    end
  end

  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end 
  
  def set_memberships
    self.invitations.each {|i| Membership.create(:user => self, :site => i.site, :role => Role.member, :passcode => i.site.passcode) }
  end
  
  def ical
    @events = Event.for_user(self)
    RiCal.Calendar do |cal|
      @events.each do |e|
        cal.event do |event|
          event.summary = e.name.to_s
          event.description = e.description.to_s
          event.dtstart =  e.start_at
          event.dtend = e.end_at
          event.location = e.location.to_s
        end
      end
    end
  end
  
  protected
  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end


	
end