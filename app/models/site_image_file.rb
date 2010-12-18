class SiteImageFile
    
  include Reloadable
    
  attr_accessor :id, :file
  attr_reader :filename
           
  def initialize(id,file)
    @id = id
    @file = file
    @filename =  base_part_of(file.original_filename)
    @content_type = file.content_type.chomp
  end
     
  def base_part_of(file_name)
    name = File.basename(file_name)
    name.gsub(/[^\w._-]/, '')
  end
     
  def save
    is_saved = false
    begin
      if @file
        if @content_type =~ /^image/    
          current_image = SiteImage.find(@id.to_i)
          #Make the directory for the id
          Dir.mkdir("#{RAILS_ROOT}/public/images/site_images/#{@id}") unless File.exist?("#{RAILS_ROOT}/public/images/site_images/#{@id}")
          #Then create the temp file
          File.open("#{RAILS_ROOT}/public/images/site_images/#{@id}/#{@filename}", "wb") do |f|
            f.write(@file.read)
          end
          image_crop("#{@filename}")
          #update the current site_image
          image_names = image_names("#{@filename}")
          File.open("#{RAILS_ROOT}/public/yo.txt", "wb") do |f|
            f.write(image_names)
          end
          current_image.update_attributes("tiny" => image_names[0], "small" => image_names[1], "medium" => image_names[2], "large" => image_names[3], "original" => image_names[4])
          is_saved = true
        end
      end
    rescue 
      return is_saved
    end
    return is_saved
  end
  
  def image_crop(image_title)
    #find the extension for this file
    image_file_extension = image_title[image_title.rindex(".") .. image_title.length].strip.chomp
    
    #Rename the originally uploaded image
    File.rename("#{RAILS_ROOT}/public/images/site_images/#{@id}/#{image_title}", "#{RAILS_ROOT}/public/images/site_images/#{@id}/original#{image_file_extension}")
    
    image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/images/site_images/#{@id}/original#{image_file_extension}")
    
    image.resize "640X"
    image.write("#{RAILS_ROOT}/public/images/site_images/#{@id}/large#{image_file_extension}")  

    image.resize "320X"
    image.write("#{RAILS_ROOT}/public/images/site_images/#{@id}/medium#{image_file_extension}")
    
    image.resize "120X"
    image.write("#{RAILS_ROOT}/public/images/site_images/#{@id}/small#{image_file_extension}")

    image.resize "50X"
    image.write("#{RAILS_ROOT}/public/images/site_images/#{@id}/tiny#{image_file_extension}")  

    # File.delete("#{RAILS_ROOT}/public/images/site_images/#{@id}/original#{image_file_extension}")
  end
     
  def image_names(image_title)
    image_file_extension = image_title[image_title.rindex(".") .. image_title.length].strip.chomp
    #Generate an array containing the url of all the images
    ["/images/site_images/#{@id}/tiny#{image_file_extension}", "/images/site_images/#{@id}/small#{image_file_extension}", "/images/site_images/#{@id}/medium#{image_file_extension}", "/images/site_images/#{@id}/large#{image_file_extension}",  "/images/site_images/#{@id}/original#{image_file_extension}"]
  end
     
end
