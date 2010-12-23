class SitesController < ApplicationController
  
  before_filter :authenticate_user!  

  def new
    @page_title = "Create a site"
    @site = Site.new(:time_zone => "Pacific Time (US & Canada)" )
  end 
  
  def create
    @site = Site.new(params[:site].merge(:last_edited_at => Time.now))
    @site.memberships_attributes = [{ :user => current_user, :role => Role.admin }]
    @site.pages_attributes = [ {:name => 'Welcome!', :content => '<p>Congratulations, your site is created!</p><p>The site is only visible to you (and the other members you add to the site).  This is an example page.  You can modify the content of the page by selecting "Edit this page" above.</p>', 
    :site => @site, :user => current_user, :comments_allowed => false, :last_edited_at => Time.now }]
    if @site.save
      @site.home_page.archive
      LogEntry.create!(:site => @site, :page_archive => @site.home_page.page_archives.last, :user => current_user, :description => 'site_create' )
      flash[:notice] = 'Site was successfully created.'
      Mailer::signup_thanks(current_user).deliver
      redirect_to permalink_path(@site.permalink, @site.home_page.permalink)
      return false
    else
      render :action => :new
    end
  end

  def update
    @page_title = "Edit site"
    @site = Site.not_deleted.find(params[:id])
    if current_user.can_edit?(@site) && @site.update_attributes(params[:site])
      LogEntry.create!(:site => @site, :user => current_user, :description => 'site_update' )
      flash[:notice] = 'Site was successfully updated.'
      redirect_to permalink_path(@site.permalink, @site.home_page.permalink)
      return false
    end
  end
  
  def edit
    @page_title = "Edit site"
    @site = Site.not_deleted.find(params[:id])
    site_editor_required!
  end

  def destroy
    @site = Site.not_deleted.find(params[:id])
    if current_user.can_admin? @site
      @site.mark_deleted!
      flash[:notice] = 'Site was successfully deleted.'
    end
    redirect_to :root
  end

end
