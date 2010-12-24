class Admin::SitesController < Admin::AdminController
  
  before_filter :authenticate_user!

  def index
    @page_title = "Sites"
    @sites = Site.not_deleted.all.paginate
  end  

end
