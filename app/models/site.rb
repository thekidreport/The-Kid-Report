class Site < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  accepts_nested_attributes_for :memberships, :allow_destroy => true
  
  has_many :users, :through => :memberships
  has_many :editors, :through => :memberships, :source => 'user', :conditions => ["memberships.role_id in (?)", [2, 3]]
  has_many :admins, :through => :memberships, :source => 'user', :conditions => ["memberships.role_id = ?", 3]
  has_many :pages, :dependent => :destroy
  accepts_nested_attributes_for :pages, :allow_destroy => true
  
  has_many :log_entries, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  
  has_attached_file :logo, 
    :storage => :s3, 
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
    :path => "/site_logos/:id/:style/:filename",
    :default_style => :original,
    :styles => { :original => "140x" }

  validates_presence_of :name
  
  before_save :set_permalink

  def set_permalink
    self.permalink = self.unique_permalink
  end
  
  def unique_permalink
    unique_name = self.name.parameterize
    index = 0
    while Site.where(['permalink = ? AND id != ?', unique_name, self.id.to_i]).any?
      index += 1
      unique_name = "#{self.name.parameterize}-#{index}"
    end
    return unique_name
  end

  def home_page
    self.pages.order('position').first
  end

  def visible_pages
    self.pages.find_all(["visibility = 'visible'"]) 
  end

  def exposed_pages page
    exposed_pages = Array.new
    if !page.nil?
      exposed_pages.concat page.exposed
    end
    exposed_pages.concat self.top_level_pages_visible
    exposed_pages.uniq!
    return exposed_pages
  end

  def top_level_pages
    tlp = self.pages.find_all(["parent_id is null"]) 
    if tlp.empty?
      tlp << self.pages[0]
    end
    return tlp
  end

  def top_level_pages_visible
    tlpv = self.pages.find_all(["parent_id is null AND visible is TRUE"])
    if tlpv.empty? && self.pages[0]
      tlpv << self.pages[0]
    end
    return tlpv
  end

  


end