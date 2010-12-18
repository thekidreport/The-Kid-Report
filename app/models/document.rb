class Document < ActiveRecord::Base
  belongs_to :site
  belongs_to :user
  
  has_many :attachments
  has_many :pages, :through => :attachments
    
  has_attached_file :file, 
    :storage => :s3, 
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
    :path => "/attachments/:id/:style/:filename",
    :styles => {
       :large => "640x800",
       :medium => "210x",
       :small => "80x80#"
    }

  scope :photo, where("file_content_type like '%image%'")
  
  before_post_process :is_image?
  def is_image?
    !(file_content_type =~ /^image/).nil?
  end
  
  def name
    file_file_name
  end
  

end