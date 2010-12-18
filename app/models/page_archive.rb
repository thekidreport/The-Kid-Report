class PageArchive < ActiveRecord::Base
  belongs_to :page
  belongs_to :user

  def self.load page
    archive = PageArchive.new
    archive.name = page.name
    archive.content = page.content
    archive.page_id = page.id
    archive.user_id = page.user_id
    return archive
  end

  def page
    page = Page.find(self.page_id)
    page.name = self.name
    page.content = self.content
    page.user_id = self.user_id
    return page
  end
end