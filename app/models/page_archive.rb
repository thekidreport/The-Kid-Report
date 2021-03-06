class PageArchive < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  has_one :log_entry, :as => :loggable

  def self.load page
    archive = PageArchive.new
    archive.name = page.name
    archive.content = page.content
    archive.page_id = page.id
    archive.user_id = page.user_id
    return archive
  end

end