class PhotosController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @photos = @site.documents.photo
  end

end