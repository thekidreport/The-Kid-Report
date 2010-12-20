class PhotosController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :site_member_required!
  
  def index
    @photos = @site.documents.photo
  end

end