class SiteImage < ActiveRecord::Base
  before_destroy :delete_image_directory

  belongs_to :site
  belongs_to :user

  def rmtree(directory)
    Dir.foreach(directory) do |entry|
      next if entry =~ /^\.\.?$/     # Ignore . and .. as usual
      path = directory + "/" + entry
      if FileTest.directory?(path)
        rmtree(path)
      else
        File.delete(path)
      end
    end
    Dir.delete(directory)
  end

  def delete_image_directory
    image_dir = "#{RAILS_ROOT}/public/images/site_images/#{self.id}"
    if File.exist?(image_dir)
      begin
        rmtree(image_dir)
      rescue
      end
    end
  end
  
  def uri
    "http://#{self.site.domain.name}/image/show/#{self.id}"
  end
  
end