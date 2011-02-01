class Site < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  accepts_nested_attributes_for :memberships, :allow_destroy => true
  
  has_many :users, :through => :memberships
  has_many :editors, :through => :memberships, :source => 'user', :conditions => ["memberships.role_id in (?)", [2, 3]]
  has_many :admins, :through => :memberships, :source => 'user', :conditions => ["memberships.role_id = ?", 3]
  has_many :pages, :dependent => :destroy
  has_many :events
  accepts_nested_attributes_for :pages, :allow_destroy => true
  
  has_many :log_entries, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  
  has_attached_file :logo, 
    :storage => :s3, 
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
    :path => "/site_logos/:id/:style/:filename",
    :default_style => :original,
    :styles => { :original => "180x" }
    
  scope :not_deleted, where('sites.deleted_at is null')
  scope :with_recent_changes, lambda { where('sites.last_edited_at > ?', 1.hour.ago) }
  scope :with_reminders, lambda { where('events.remind_on = ?', Date.today).joins(:events) }

  validates_presence_of :name
  
  before_save :set_permalink

  def set_permalink
    self.permalink = self.unique_permalink
  end
  
  def unique_permalink
    unique_name = self.name.parameterize
    index = 0
    while Site.not_deleted.where(['permalink = ? AND id != ?', unique_name, self.id.to_i]).any?
      index += 1
      unique_name = "#{self.name.parameterize}-#{index}"
    end
    return unique_name
  end

  def home_page
    self.pages.not_deleted.order('position').first
  end
  
  def events_count
    self.events.event_strips_for_month(Date.civil(Time.zone.now.year, Time.zone.now.month)).flatten.compact.count
  end
  
  def mark_deleted
    self.deleted_at = Time.now
  end
  def mark_deleted!
    mark_deleted
    self.save
  end
end