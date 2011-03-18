class SitesController < ApplicationController
  
  before_filter :load_site_by_id, :only => [:edit, :edit_top_story, :update, :destroy]
  before_filter :authenticate_user!, :only => :show, :if => :site_members_only
  before_filter :authenticate_user!, :except => :show
  before_filter :site_admin_required!, :only => [:edit, :edit_top_story, :update, :destroy]
  
  
  TINY_MCE_OPTIONS = { :theme => "advanced",
                              :plugins => [:table],
                              :theme_advanced_toolbar_align => "left",
                              :theme_advanced_buttons1 => "formatselect,bold,italic,forecolor,link,unlink,image,separator,bullist,numlist",
                              :theme_advanced_buttons2 => "justifyleft,justifycenter,separator,code,separator,tablecontrols",
                              :theme_advanced_buttons3 => "",
                              :theme_advanced_toolbar_location => "top",
                              :theme_advanced_statusbar_location => "bottom",
                              :theme_advanced_resizing => true,
                              :theme_advanced_resize_horizontal => false,
                              :theme_advanced_path => false,
                              :extended_valid_elements => "font[size|color|face]",
                              :external_image_list_url => '../../photos.js'
                            }
                            
  uses_tiny_mce :options => TINY_MCE_OPTIONS, :only => [:edit_top_story]
  
  def show
    @site = Site.not_deleted.find_by_permalink(params[:site_permalink])
    
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = @site.events.event_strips_for_month(@shown_month)
  end

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
      LogEntry.create!(:site => @site, :loggable => @site, :user => current_user, :description => 'site_create' )
      flash[:notice] = 'Site was successfully created.'
      Mailer::signup_thanks(current_user).deliver
      redirect_to permalink_path(@site.permalink, @home_page.permalink)
      return false
    else
      render :action => :new
    end
  end

  def update
    if current_user.can_edit?(@site) && @site.update_attributes(params[:site])
      LogEntry.create!(:site => @site, :loggable => @site, :user => current_user, :description => 'site_update' )
      flash[:notice] = 'Site was successfully updated.'
      redirect_to site_root_path(@site.permalink)
    else
      if params[:site][:top_story]
        render :action => :edit_top_story
      else
        render :action => :edit
      end
    end
  end
  
  def edit
    @page_title = "Edit site"
  end
  
  def edit_top_story
    @page_title = "Edit Top Story"
  end

  def destroy
    if current_user.can_admin? @site
      @site.mark_deleted!
      flash[:notice] = 'Site was successfully deleted.'
    end
    redirect_to :root
  end
  
  private
  def load_site_by_id
    @site = Site.not_deleted.find(params[:id])
  end

end
