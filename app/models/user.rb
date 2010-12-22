require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  
  has_many :memberships, :dependent => :destroy
  has_many :messages, :dependent => :nullify
  has_many :recipients, :dependent => :destroy
  has_many :messages_receive, :through => :recipients
  has_many :log_entries, :dependent => :nullify
  has_many :sites, :through => :memberships

	EMAIL_REGEX = /([_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name)))/
	EMAIL_NAME_REGEX = /([\w | \s]+)/

	validates_presence_of :email, :message => 'Email is required'
	validates_uniqueness_of :email, :on => :save, :message => 'This email is already signed up!'
	validates_format_of :email, :with => EMAIL_REGEX, :message => 'The formatting for this email address is incorrect'
	
	after_create :send_new_user_alert

	def display_name
		if self.name.present?
			return self.name
		elsif email && email.include?('@')
			return email.split('@')[0].humanize 
		else
			return "Friend"
		end
	end
	
	def member_of? site
	  site.users.include?(self) || self.admin?
  end
	
	def can_edit? site
	  site.editors.include?(self) || self.admin?
  end
  
  def can_admin? site
    site.admins.include?(self) || self.admin?
  end
  
  def send_new_user_alert
    Mailer::new_user_alert(self).deliver
  end
	
end