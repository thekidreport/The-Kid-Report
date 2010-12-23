class Page < ActiveRecord::Base
  belongs_to :site
  
  has_many :page_archives, :order => 'created_at DESC', :dependent => :destroy
  has_many :attachments, :dependent => :destroy
  has_many :documents, :through => :attachments
  accepts_nested_attributes_for :attachments, :allow_destroy => true
  
  has_many :comments, :order => 'updated_at DESC, created_at DESC', :dependent => :destroy
  belongs_to :user
  has_many :log_entries, :through => :page_archives

  before_create :set_visitor_count_start_at
  
  before_save :set_permalink

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:site_id, :deleted_at]
  
  scope :top_level, where('parent_id is NULL')
  scope :visible, where('pages.visible = ?', true)
  scope :with_recent_changes, where('pages.updated_at > ?', 1.hour.ago)
  scope :not_deleted, where('pages.deleted_at is null')

  acts_as_list :scope => :site

  def set_permalink
    self.permalink = self.unique_permalink
  end
  
  def unique_permalink
    unique_name = self.name.parameterize
    index = 0
    while self.site.pages.not_deleted.where(['permalink = ? AND id != ?', unique_name, self.id.to_i]).any?
      index += 1
      unique_name = "#{self.name.parameterize}-#{index}"
    end
    return unique_name
  end

  def set_visitor_count_start_at
    self.visitor_count_start_at = Time.now
  end

  def archive
    archive = PageArchive.load self
    archive.save
  end
  
  def not_deleted
    deleted_at == nil
  end
  
  def mark_deleted
    self.deleted_at = Time.now
  end
  def mark_deleted!
    mark_deleted
    self.save
  end
end