class Admin::SitesController < Admin::AdminController
  
  before_filter :authenticate_user!

  def index
    @page_title = "Sites"
    @sites = Site.all.paginate
  end  

end
